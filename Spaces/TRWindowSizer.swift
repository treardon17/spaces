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
    
    init(shortcutKeys:[String], shortcutModifiers:[String], xProp:CGFloat, yProp:CGFloat, widthProp: CGFloat, heightProp: CGFloat){
        super.init()
        self.windowSize = TRWindowSize(xProp: xProp, yProp: yProp, widthProp: widthProp, heightProp: heightProp)
        self.hotkey = TRHotKeyManager.shared.createHotKey(keys: shortcutKeys, modifiers: shortcutModifiers, action: self.callback)
    }
    
    init(shortcutKeys:[String], shortcutModifiers:[String], size:TRWindowSize){
        super.init()
        self.windowSize = size
        self.hotkey = TRHotKeyManager.shared.createHotKey(keys: shortcutKeys, modifiers: shortcutModifiers, action: self.callback)
    }
    
    func callback(){
        self.resizeWindows()
    }
    
    func setWindowsToResize(windows:[SIWindow], inFrame frame:CGRect){
        self.windows.removeAll()
        self.windows.append(contentsOf: windows)
        self.frame = frame
    }
    
    // ********************************************************
    // ********************************************************
    // TODO: I'm guessing there's a problem with this function
    // or getSizedRectForFrame on external monitors...
    // ********************************************************
    // ********************************************************
    func resizeWindow(window:SIWindow){
        var frame:CGRect? = nil;
        if let screen = window.screen(){
            print("screen is:", screen.frame)
            if let myFrame = self.frame{
                frame = myFrame
            }else{
//                frame = self.windowSize.getSizedRectForFrame(frame: screen.frame)
                frame = self.windowSize.getInvertedSizedRectForFrame(frame: screen.frame)
            }
            if let frame = frame{
                print("frame is:", frame)
                window.setFrame(frame)
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
