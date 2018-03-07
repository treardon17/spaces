//
//  WindowManager.swift
//  Spaces
//
//  Created by Tyler Reardon on 7/25/17.
//  Copyright © 2017 Tyler Reardon. All rights reserved.
//

import Foundation
import Silica

class TRWindowManager: TRManagerBase{
    /// Shared instance of WindowManager
    static let shared = TRWindowManager()
    var listeningApps = [String: TRApplication]()
    var windows = [String:TRWindow]()
    var overlayWindow: TROverlayWindow!
    var isMouseDragging: Bool = false
    var windowPreviewSnapped: Bool = false
    var newWindowFrame: CGRect?
    var windowToResize: SIWindow?
    var positionList = [Bool]()
    
    // Sizers
    var sizers = [TRWindowSizer]()

    // Mouse handlers
    var mouseupEventHandler: GlobalEventMonitor?
    var mousedownEventHandler: GlobalEventMonitor?
    var mousedragEventHandler: GlobalEventMonitor?
    
    private var _runningApps = [String:TRApplication]()
    var runningApps:[String:TRApplication]{
        get{
            self.updateRunningApps()
            return _runningApps
        }
    }
    
    var currentActiveApp:TRApplication?{
        get{
            let pid = NSWorkspace.shared.frontmostApplication?.processIdentifier
            return self.getAppForPID(pid: pid)
        }
    }
    
    override init(){
        super.init()
        
        // Set defaults
        self.overlayWindow = TROverlayWindow()
        
        // Initializations
        self.setupListeners()
        self.initSizers()
    }
    
    deinit {
        self.removeListeners()
    }
    
    private func initSizers() {
        for json in TRConfigManager.shared.shortcuts {
            let sizeID = json["actionIdentifier"].string
            if let sizeID = sizeID {
                let size = TRConfigManager.shared.sizes[sizeID]
                if let size = size {
                    if let shortcutKeys = json["characters"].arrayObject as? [String], let modifiers = json["modifiers"].arrayObject as? [String]{
                        self.sizers.append(TRWindowSizer(shortcutKeys: shortcutKeys, shortcutModifiers: modifiers, size: size))
                    }
                }
            }
        }
    }
    
    private func setupListeners(){
        self.updateListeners()
        
        // We need to listen to mouse down events to ensure that the preview is shown at the correct time
        self.mousedownEventHandler = GlobalEventMonitor(mask: NSEvent.EventTypeMask.leftMouseDown, handler: self.mousedownEvent(event:))
        self.mousedownEventHandler?.start()
        
        // We need to listen to mouse drag events so we know where the window is
        self.mousedragEventHandler = GlobalEventMonitor(mask: NSEvent.EventTypeMask.leftMouseDragged, handler: self.mousedragEvent(event:))
        self.mousedragEventHandler?.start()
    }
    
    private func removeListeners(){
        for (_, app) in self.runningApps{
            app.removeAllObservers()
        }
        
        self.mouseupEventHandler?.stop()
        self.mouseupEventHandler = nil
        
        self.mousedownEventHandler?.stop()
        self.mousedownEventHandler = nil
        
        self.mousedragEventHandler?.stop()
        self.mousedragEventHandler = nil
    }
    
    private func updateListeners(){
        // Get a list of all the updated apps
        let runningApps = self.runningApps
        
        // Gets all the new apps, iterates through them,
        // and sets event handlers for each event
        let newApps = Set(runningApps.keys).subtracting(self.listeningApps.keys)
        for id in newApps{
            let app = self.runningApps[id]!
            self.listeningApps[id] = app
            
            // Listener callbacks
            app.onMove = self.onAppMove(element:)
            app.onMoved = self.onAppMoved(element:)
            app.onResized = self.onAppResized(element:)
            app.onApplicationActivated = self.onAppApplicationActivated(element:)
            app.onCreate = self.onAppCreate(element:)
            app.onFocusChanged = self.onAppFocusChanged(element:)
            app.onMiniaturized = self.onAppMiniaturized(element:)
            app.onDeminiaturized = self.onAppDeminiaturized(element:)
        }
        
        // We need to get the apps that aren't running anymore and stop listening to them
        let oldApps = Set(self.listeningApps.keys).subtracting(runningApps.keys)
        for id in oldApps{
            let app = self.listeningApps.removeValue(forKey: id)
            app?.removeAllObservers()
        }
    }
    
    ///Returns a list of all the running applications
    private func getAllRunningApps() -> [NSRunningApplication]{
        let workspace = NSWorkspace.shared
        let runningApplications = workspace.runningApplications;
        return runningApplications;
    }
    
    ///Returns a list of windows for a given application
    func getWindowsFor(_ app:NSRunningApplication) -> [SIWindow]?{
        let myApp = SIApplication(runningApplication: app)
        let windows = myApp.windows()
        return windows as? [SIWindow]
    }
    
    func updateRunningApps(){
        self._runningApps.removeAll()
        let apps = self.getAllRunningApps()
        for app in apps{
            let myApp = TRApplication(runningApplication: app)
            let pid = myApp.app.processIdentifier()
            self._runningApps[self.getAppKeyFromPID(pid: pid)] = myApp
        }
    }
    
    func getAppKeyFromPID(pid: pid_t) -> String{
        return "\(pid)"
    }
    
    func getAppForPID(pid: pid_t?) -> TRApplication?{
        if let pid = pid{
            return self.runningApps[self.getAppKeyFromPID(pid: pid)]
        }else{
            return nil
        }
    }
    
    
    // User Interface
    
    func showOverlayWindow(frame: CGRect, animateWidth: Bool, fromLeft: Bool, animateHeight: Bool, fromTop: Bool){
        // Setup frame dimensions
        let width = frame.size.width
        let height = frame.size.height
        let x = frame.origin.x;
        let y = frame.origin.y;
        let startRect = CGRect(x: (fromLeft ? x : x + width), y: (fromTop ? y + height : y ), width: (animateWidth ? 0 : width), height: (animateHeight ? 0 : height))
        
        // Size and show window
        self.overlayWindow?.setAnimationFrames(startFrame: startRect.toNSRect(), endFrame: frame.toNSRect())
        self.overlayWindow?.show(animated: (animateWidth || animateHeight))
    }
    
    func hideOverlayWindow(){
        self.overlayWindow.close()
        self.overlayWindow.setDimensions(NSRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    func cancelCurrentAnimationsIfNeeded(app: TRApplication){
        if app.id == self.currentActiveApp?.id{
            // If no mouse buttons are pressed, we hide the overlay
            if NSEvent.pressedMouseButtons < 1{
                self.hideOverlayWindow()
                self.windowFinishedMoving(window: self.windowToResize)
            }
        }
    }
    
    func cancelOverlayAnimation(){
        self.overlayWindow.cancelCurrentAnimation()
    }
    
    // Listeners
    
    func onAppMove(element: SIAccessibilityElement){
        let window = element as? SIWindow
        if let window = window, let siApp = window.app(){
            let app = TRApplication(siApplication: siApp)
            Logger.log("app moved: \(String(describing: app?.title))")
            self.appMoving(window: window)
            if let app = app {
                self.cancelCurrentAnimationsIfNeeded(app: app)
            }
        }
    }
    
    func onAppMoved(element: SIAccessibilityElement){
        let window = element as? SIWindow
        if let window = window, let siApp = window.app(){
            let app = TRApplication(siApplication: siApp)
            Logger.log("app finished moving \(String(describing: app?.title))")
            if let app = app {
                self.cancelCurrentAnimationsIfNeeded(app: app)
            }
        }
    }
    
    func onAppResized(element: SIAccessibilityElement){
        let window = element as? SIWindow
        if let window = window, let siApp = window.app(){
            let app = TRApplication(siApplication: siApp)
            Logger.log("app resized: \(String(describing: app?.title))")
            if let app = app {
                self.cancelCurrentAnimationsIfNeeded(app: app)
            }
        }
    }
    
    func onAppApplicationActivated(element: SIAccessibilityElement){
        let window = element as? SIWindow
        if let window = window {
            if let siApp = window.app() {
                let app = TRApplication(siApplication: siApp)
                Logger.log("app activated: \(String(describing: app?.title))")
                if let app = app {
                    self.cancelCurrentAnimationsIfNeeded(app: app)
                }
            }
        }
    }
    
    func onAppCreate(element: SIAccessibilityElement){
        let window = element as? SIWindow
        if let window = window, let siApp = window.app(){
            let app = TRApplication(siApplication: siApp)
            Logger.log("app created: \(String(describing: app?.title))")
            self.updateListeners()
            if let app = app {
                self.cancelCurrentAnimationsIfNeeded(app: app)
            }
        }
    }
    
    func onAppFocusChanged(element: SIAccessibilityElement){
        let window = element as? SIWindow
        if let window = window, let siApp = window.app(){
            let app = TRApplication(siApplication: siApp)
            Logger.log("focus change: \(String(describing: app?.title))")
            if let app = app {
                self.cancelCurrentAnimationsIfNeeded(app: app)
            }
        }
    }
    
    func onAppMiniaturized(element: SIAccessibilityElement){
        let window = element as? SIWindow
        if let window = window, let siApp = window.app(){
            let app = TRApplication(siApplication: siApp)
            Logger.log("app miniaturized: \(String(describing: app?.title))")
        }
    }
    
    func onAppDeminiaturized(element: SIAccessibilityElement){
        let window = element as? SIWindow
        if let window = window, let siApp = window.app(){
            let app = TRApplication(siApplication: siApp)
            Logger.log("app deminiaturized: \(String(describing: app?.title))")
        }
    }
    
    
    // Action handlers
    
    private func appMoving(window: SIWindow?){
//        if let window = window, let screen = TRWindowManager.getScreenMouseIsOn(){
//            
//            // Listen for mouseup events so we know when the drag has finished
//            if self.mouseupEventHandler == nil{
//                self.mouseupEventHandler = GlobalEventMonitor(mask: NSEvent.EventTypeMask.leftMouseUp, handler: self.mouseupEvent(event:))
//                self.mouseupEventHandler?.start()
//            }
//            
//            let screenFrame = screen.frameWithoutDockOrMenu()
//            let margin:CGFloat = screenFrame.width * 0.02
//            let windowLeftPos = screenFrame.origin.x
//            let windowRightPos = screenFrame.origin.x + screenFrame.width
//            let windowBottomPos = screenFrame.origin.y + screenFrame.height
//            let windowTopPos = screenFrame.origin.y
//            
//            let fullScreenFrame = screen.frameIncludingDockAndMenu()
//            let menuBarHeight = NSApplication.shared.mainMenu!.menuBarHeight
//            let dockHeight = fullScreenFrame.height - screenFrame.height - menuBarHeight
//            
//            // We need to set the origin of the mouse pointer to be the bottom because we're using
//            //  CGRects rather than NSRects here, and the origin is different
//            var mouseLocation = NSEvent.mouseLocation
//            mouseLocation.setOriginFromFrame(frame: fullScreenFrame)
//            
//            let isOnLeft = ( mouseLocation.x >= windowLeftPos && mouseLocation.x < windowLeftPos + margin )
//            let isOnRight = ( mouseLocation.x <= windowRightPos && mouseLocation.x > windowRightPos - margin )
//            let isOnTop = ( mouseLocation.y >= windowTopPos && mouseLocation.y < windowTopPos + margin)
//            let isOnBottom = ( mouseLocation.y <= windowBottomPos && mouseLocation.y > windowBottomPos - margin )
//            let isTopLeft = isOnLeft && isOnTop
//            let isBottomLeft = isOnLeft && isOnBottom
//            let isTopRight = isOnRight && isOnTop
//            let isBottomRight = isOnRight && isOnBottom
//            let prevPositionList = self.positionList
//            
////            print("top:\(isOnTop), bottom:\(isOnBottom), left:\(isOnLeft), right:\(isOnRight)")
////            print("top left:\(isTopLeft), bottom left:\(isBottomLeft), top right:\(isTopRight), bottom right:\(isBottomRight)")
//            
//            var windowRect:CGRect? = nil
//            var overlayRect:CGRect? = nil
//            var animateWidth = false
//            var animateHeight = false
//            var fromLeft = false
//            var fromTop = false
//            var shouldResize = false
//            
//            // TOP LEFT
//            if isTopLeft {
//                let width = screenFrame.width / 2
//                let height = screenFrame.height / 2
//                windowRect = CGRect(x: windowLeftPos, y: windowTopPos, width: width, height: height)
//                overlayRect = CGRect(x: windowLeftPos, y: dockHeight, width: width, height: height)
//                animateWidth = true
//                fromLeft = true
//                animateHeight = true
//                fromTop = true
//            }
//                
//            // BOTTOM LEFT
//            else if isBottomLeft {
//                let width = screenFrame.width / 2
//                let height = screenFrame.height / 2
//                windowRect = CGRect(x: windowLeftPos, y: windowBottomPos, width: width, height: height)
//                overlayRect = CGRect(x: windowLeftPos, y: dockHeight, width: width, height: height)
//                animateWidth = true
//                fromLeft = true
//                animateHeight = true
//                fromTop = false
//            }
//                
//            // TOP RIGHT
//            else if isTopRight{
//                let width = screenFrame.width / 2
//                let height = screenFrame.height / 2
//                windowRect = CGRect(x: windowRightPos - width, y: windowTopPos - height, width: width, height: height)
//                overlayRect = CGRect(x: windowRightPos - width, y: dockHeight, width: width, height: height)
//                animateWidth = true
//                fromLeft = false
//                animateHeight = true
//                fromTop = true
//            }
//                
//            // BOTTOM RIGHT{
//            else if isBottomRight {
//                let width = screenFrame.width / 2
//                let height = screenFrame.height / 2
//                windowRect = CGRect(x: windowRightPos - width, y: windowBottomPos, width: width, height: height)
//                overlayRect = CGRect(x: windowRightPos - width, y: dockHeight, width: width, height: height)
//                animateWidth = true
//                fromLeft = false
//                animateHeight = true
//                fromTop = false
//            }
//            
//            // LEFT SIDE
//            else if isOnLeft {
//                let width = screenFrame.width / 2
//                let height = screenFrame.height
//                windowRect = CGRect(x: windowLeftPos, y: windowTopPos, width: width, height: height)
//                overlayRect = CGRect(x: windowLeftPos, y: dockHeight, width: width, height: height)
//                animateWidth = true
//                fromLeft = true
//                animateHeight = false
//            }
//            
//            // RIGHT SIDE
//            else if isOnRight {
//                let width = screenFrame.width / 2
//                let height = screenFrame.height
//                windowRect = CGRect(x: windowRightPos - width, y: windowTopPos, width: width, height: height)
//                overlayRect = CGRect(x: windowRightPos - width, y: dockHeight, width: width, height: height)
//                animateWidth = true
//                fromLeft = false
//                animateHeight = false
//            }
//            
//            // TOP SIDE
//            else if isOnTop{
//                let width = screenFrame.width
//                let height = screenFrame.height
//                windowRect = CGRect(x: windowLeftPos, y: windowTopPos, width: width, height: height)
//                overlayRect = CGRect(x: windowLeftPos, y: dockHeight, width: width, height: height)
//                animateWidth = false
//                fromLeft = true
//                animateHeight = true
//                fromTop = true
//            }
//            
//            // BOTTOM SIDE
//            else if isOnBottom{
//                let width = screenFrame.width
//                let height = screenFrame.height
//                windowRect = CGRect(x: windowLeftPos, y: windowTopPos, width: width, height: height)
//                overlayRect = CGRect(x: windowLeftPos, y: dockHeight, width: width, height: height)
//                animateWidth = false
//                fromLeft = true
//                animateHeight = true
//                fromTop = false
//            }
//            
//            self.positionList = [isOnLeft, isOnRight, isOnTop, isOnBottom, isTopLeft, isTopRight, isBottomLeft, isBottomRight]
//            shouldResize = ( isOnLeft || isOnRight || isOnTop || isOnBottom )
//            if ( overlayRect != nil && (shouldResize && !self.windowPreviewSnapped || self.positionList != prevPositionList) ){
//                let convertedRect = screen.backingAlignedRect(overlayRect!, options: AlignmentOptions.alignAllEdgesInward)
//                self.showOverlayWindow(frame: convertedRect, animateWidth: animateWidth, fromLeft: fromLeft, animateHeight: animateHeight, fromTop: fromTop)
//                self.windowToResize = window
//            }else if( !shouldResize ){
//                self.cancelOverlayAnimation()
//                self.hideOverlayWindow()
//            }
//            
//            self.windowPreviewSnapped = shouldResize
//            if let windowRect = windowRect {
//                self.newWindowFrame = screen.backingAlignedRect(windowRect, options: AlignmentOptions.alignAllEdgesInward)
//            }
//        }
    }
    
    private func windowFinishedMoving(window: SIWindow?){
        self.resizeCurrentWindowIfNeeded()
        
        // We're not observing a window any longer
        self.windowToResize = nil
        
        // We don't want to listen to these events any longer
        self.mouseupEventHandler?.stop()
        self.mouseupEventHandler = nil
        
        // Remove the overlay
        self.hideOverlayWindow()
    }
    
    
    private func resizeCurrentWindowIfNeeded(){
        // If rect is defined, that means we should resize the window
        if let rect = self.newWindowFrame, let window = self.windowToResize{
            window.setFrame(rect)
        }
    }
    
    
    // Mouse Events
    
    private func mouseupEvent(event: NSEvent?){
        self.windowFinishedMoving(window: self.windowToResize)
    }
    
    private func mousedownEvent(event: NSEvent?){
        self.windowPreviewSnapped = false
    }
    
    private func mousedragEvent(event: NSEvent?){
        // Update the window position more frequently
        self.appMoving(window: self.windowToResize)
    }
    
    // Utilities
    
    public static func getScreenMouseIsOn() -> NSScreen?{
        let mousePos = NSEvent.mouseLocation
        let screens = NSScreen.screens
        for screen in screens{
            let point = CGPoint(x: mousePos.x, y: mousePos.y)
            if screen.frame.contains(point){
                return screen
            }
        }
        return nil;
    }
    
}
