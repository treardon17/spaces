//
//  TRWindowSizer.swift
//  Spaces
//
//  Created by Tyler Reardon on 8/2/17.
//  Copyright © 2017 Tyler Reardon. All rights reserved.
//

import Foundation
import Silica

class TRWindowSizer: NSObject{
    var windowSize:TRWindowSize!
    var hotkey:TRHotKey?
    var windows = [SIWindow]()
    var frame:CGRect?
    
    init(hotkey:TRHotKey, size:TRWindowSize) {
        self.hotkey = hotkey
        self.windowSize = size
    }
    
    init(shortcutKeys:[String], shortcutModifiers:[String], size:TRWindowSize){
        super.init()
        self.windowSize = size
        self.hotkey = TRHotKeyManager.shared.createHotKey(keys: shortcutKeys, modifiers: shortcutModifiers, action: self.trigger)
    }
    
    init(size:TRWindowSize) {
        super.init()
        self.windowSize = size
    }
    
    deinit {
        self.windowSize = nil
        self.frame = nil
        if let hotkey = self.hotkey {
            TRHotKeyManager.shared.removeHotKey(identifier: hotkey.identifier)
        }
    }
    
    func trigger(){
        self.resizeWindows()
    }
    
    func setWindowsToResize(windows:[SIWindow], inFrame frame:CGRect){
        self.windows.removeAll()
        self.windows.append(contentsOf: windows)
        self.frame = frame
    }
    
    func resizeWindow(window:SIWindow){
        var frame:CGRect? = nil;
        if let screen = window.screen(){
            if let myFrame = self.frame{
                frame = myFrame
            }else{
                frame = self.windowSize.getSizedRectForScreen(screen: screen, window: window)
            }
            if let frame = frame{
                window.setFrame(frame)
                if frame.equalTo(window.frame()) {
                    // success
                    print("Resize success!")
                } else {
                    // fail
                    print("Window could not be resized")
                    let newFrame = self.windowSize.getRectForUnmutableWindow(screen: screen, window: window)
                    window.setFrame(newFrame)
                }
            }
        }
    }
    
    func resizeWindows(){
        if self.windows.count == 0{
            if let window = SIWindow.focused(){
                self.resizeWindow(window: window)
            }
        }else{
            for window in self.windows{
                self.resizeWindow(window: window)
            }
        }
    }
    
    
}
