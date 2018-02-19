//
//  TRApplication.swift
//  Spaces
//
//  Created by Tyler Reardon on 7/26/17.
//  Copyright © 2017 Tyler Reardon. All rights reserved.
//

import Foundation
import Silica

typealias closure = ((SIAccessibilityElement)->Void)?

class TRApplication: NSObject{
    var app:SIApplication!
    var runningApp:NSRunningApplication!
    
    // Action handlers --------------

    // Application
    
    private var _onCreate:closure = nil
    var onCreate:closure{
        set{
            self._onCreate = newValue
            if(newValue != nil){
                self.observe(notification: kAXCreatedNotification, callback: self.onCreate)
            }else{
                self.unobserve(notification: kAXCreatedNotification)
            }
        }
        get{ return self._onCreate }
    }
    
    private var _onMove:closure = nil
    var onMove:closure{
        set{
            self._onMove = newValue
            if(newValue != nil){
                self.observe(notification: kAXMovedNotification, callback: self.onMove)
            }else{
                self.unobserve(notification: kAXMovedNotification)
            }
        }
        get{ return self._onMove }
    }
    
    private var _onMoved:closure = nil
    var onMoved:closure{
        set{
            self._onMoved = newValue
            if(newValue != nil){
                self.observe(notification: kAXWindowMovedNotification, callback: self.onMoved)
            }else{
                self.unobserve(notification: kAXWindowMovedNotification)
            }
        }
        get{ return self._onMoved }
    }
    
    private var _onMiniaturized:closure = nil
    var onMiniaturized:closure{
        set{
            self._onMiniaturized = newValue
            if(newValue != nil){
                self.observe(notification: kAXWindowMiniaturizedNotification, callback: self.onMiniaturized)
            }else{
                self.unobserve(notification: kAXWindowMiniaturizedNotification)
            }
        }
        get{ return self._onMiniaturized }
    }
    
    private var _onDeminiaturized:closure = nil
    var onDeminiaturized:closure{
        set{
            self._onDeminiaturized = newValue
            if(newValue != nil){
                self.observe(notification: kAXWindowDeminiaturizedNotification, callback: self.onDeminiaturized)
            }else{
                self.unobserve(notification: kAXWindowDeminiaturizedNotification)
            }
        }
        get{ return self._onDeminiaturized }
    }
    
    private var _onFocusChanged:closure = nil
    var onFocusChanged:closure{
        set{
            self._onFocusChanged = newValue
            if(newValue != nil){
                self.observe(notification: kAXFocusedWindowChangedNotification, callback: self.onFocusChanged)
            }else{
                self.unobserve(notification: kAXFocusedWindowChangedNotification)
            }
        }
        get{ return self._onFocusChanged }
    }
    
    private var _onApplicationActivated:closure = nil
    var onApplicationActivated:closure{
        set{
            self._onApplicationActivated = newValue
            if(newValue != nil){
                self.observe(notification: kAXApplicationActivatedNotification, callback: self.onApplicationActivated)
            }else{
                self.unobserve(notification: kAXApplicationActivatedNotification)
            }
        }
        get{ return self._onApplicationActivated }
    }
    
    private var _onResized:closure = nil
    var onResized:closure{
        set{
            self._onResized = newValue
            if(newValue != nil){
                self.observe(notification: kAXWindowResizedNotification, callback: self.onResized)
            }else{
                self.unobserve(notification: kAXWindowResizedNotification)
            }
        }
        get{ return self._onResized }
    }
    
    
    // --------------
    
    // Information --------------

    var title:String{
        get{
            let appTitle = self.app.title()
            return (appTitle != nil) ? appTitle! : ""
        }
    }
    
    var allWindows:[SIWindow]{
        get{ return self.app.windows() as! [SIWindow] }
    }
    
    var visibleWindows:[SIWindow]{
        get{ return self.app.visibleWindows() as! [SIWindow] }
    }
    
    var currentActiveWindow:SIWindow?{
        get{
            if self.runningApp.isActive{
                for window in self.allWindows{
                    if window.isActive(){
                        return window
                    }
                }   
            }
            return nil
        }
    }
    
    var id:String{
        get{
            return "\(self.app.processIdentifier())"
        }
    }
    
    //CONSTRUCTOR
    init(runningApplication: NSRunningApplication){
        let axElementRef = AXUIElementCreateApplication(runningApplication.processIdentifier)
        let application = SIApplication(axElement: axElementRef)
        self.app = application
        self.runningApp = runningApplication
    }
    
    convenience init(siApplication: SIApplication){
        let pid = siApplication.processIdentifier()
        let runningApplication = NSRunningApplication.init(processIdentifier: pid)
        self.init(runningApplication: runningApplication!)
    }
    
    private func observe(notification: String, callback:closure){
        self.app.observeNotification(notification as CFString!, with: self.app) { (accessibilityElement) in
            if let callback = callback{ callback(accessibilityElement) }
        }
    }
    
    private func unobserve(notification: String){
        self.app.unobserveNotification(notification as CFString!, with: self.app)
    }
    
    func removeAllObservers(){
        self.onMove = nil
        self.onCreate = nil
        self.onFocusChanged = nil
        self.onMiniaturized = nil
        self.onDeminiaturized = nil
        self.onApplicationActivated = nil
        self.onResized = nil
        self.onMoved = nil
    }
}
