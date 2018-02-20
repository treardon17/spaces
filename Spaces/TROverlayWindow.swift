//
//  OverlayWindow.swift
//  Spaces
//
//  Created by Tyler Reardon on 7/28/17.
//  Copyright © 2017 Tyler Reardon. All rights reserved.
//

import Foundation
import Cocoa

class TROverlayWindow: NSWindowController{
    
    var startFrame: NSRect?
    var endFrame: NSRect?
    
    init() {
        let window = NSWindow(contentRect: NSRect.zero, styleMask: NSWindow.StyleMask.borderless, backing: NSWindow.BackingStoreType.buffered, defer: true)
        super.init(window: window)
        
        if let window = self.window{
            // Set the opaque value off,remove shadows and fill the window with clear (transparent)
            window.isOpaque = false
            window.hasShadow = false
            window.backgroundColor = .black
            window.alphaValue = 0.0
            
            // Change the title bar appereance
            window.titleVisibility = .hidden
            window.titlebarAppearsTransparent = true
            
            // Set the level of the window to be always on top
            window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.maximumWindow)))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDimensions(_ dimensions: NSRect){
        if let window = self.window{
            window.setFrame(dimensions, display: true, animate: false)
        }
    }
    
    func setAnimationFrames(startFrame: NSRect, endFrame: NSRect){
        self.startFrame = startFrame
        self.endFrame = endFrame
    }
    
    func show(animated: Bool){
        self.loadWindow()
        self.showWindow(self)
        
        if let frame = self.startFrame{
            self.setDimensions(frame)
        }
        
        if let window = self.window{
            NSAnimationContext.runAnimationGroup({context in
                
                //Indicate the duration of the animation
                NSAnimationContext.current.duration = (animated ? 0.25 : 0)

                // Fade in
                window.animator().alphaValue = 0.5
                
                if let frame = self.endFrame{
                    window.animator().setFrame(frame, display: true)
                }
            }, completionHandler:{
                if let frame = self.endFrame{
                    self.setDimensions(frame)
                }
                
                self.startFrame = nil
                self.endFrame = nil
            })
        }
    }
    
    func cancelCurrentAnimation(){
        if let window = self.window{
            window.animator().accessibilityPerformCancel()
        }
    }
    
    func hide(){
        self.close()
        if let window = self.window{
            window.alphaValue = 0
        }
    }
}
