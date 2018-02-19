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
        self.hotkey = TRHotKey()
        self.hotkey?.registerShortcut(characters: shortcutKeys, modifiers: shortcutModifiers, callback: self.callback)
    }
    
    init(shortcutKeys:[String], shortcutModifiers:[String], size:TRWindowSize){
        super.init()
        self.windowSize = size
        self.hotkey = TRHotKey()
        self.hotkey?.registerShortcut(characters: shortcutKeys, modifiers: shortcutModifiers, callback: self.callback)
    }
    
    func callback(){
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
                frame = self.windowSize.getSizedRectForFrame(frame: screen.frame)
            }
            if let frame = frame{
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
