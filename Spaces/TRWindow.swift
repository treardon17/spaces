//
//  Window.swift
//  Spaces
//
//  Created by Tyler Reardon on 7/26/17.
//  Copyright © 2017 Tyler Reardon. All rights reserved.
//

import Foundation
import Cocoa

class TRWindow: NSWindow {
    let view = NSView()
    
    init() {
        super.init(contentRect: NSMakeRect(0, 0, NSScreen.main!.frame.midX, NSScreen.main!.frame.midY), styleMask: [.closable, .fullSizeContentView, .miniaturizable, .fullScreen, .resizable], backing: .buffered, defer: false)
        self.isOpaque = false
        self.center()
        self.isMovableByWindowBackground = true
        self.backgroundColor = NSColor.clear
        self.view.wantsLayer = true
        self.view.superview?.wantsLayer = true
        self.contentView = self.view
        
        // Setup shadow
        self.view.shadow = NSShadow()
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        self.view.layer!.cornerRadius = 10
        self.view.layer?.shadowOpacity = 1.0
        self.view.layer?.shadowColor = NSColor.black.cgColor
        self.view.layer?.shadowOffset = NSMakeSize(0, 0)
        self.view.layer?.shadowRadius = 20
        
        self.isReleasedWhenClosed = false
    }
    
    func showWindow() {
        self.makeKeyAndOrderFront(nil)
        self.makeKey()
        self.orderFrontRegardless()
    }
    
    convenience init(contentRect: NSRect, display: Bool) {
        self.init()
        self.setFrame(contentRect, display: display)
    }
}
