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
        super.init(contentRect: NSMakeRect(0, 0, NSScreen.main!.frame.midX, NSScreen.main!.frame.midY), styleMask: [.closable, .fullSizeContentView, .miniaturizable, .resizable, .titled], backing: .buffered, defer: false)
        self.isOpaque = false
        self.center()
        self.isMovableByWindowBackground = true
        self.backgroundColor = NSColor.clear
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        self.contentView = self.view
        
        // Setup shadow
        self.hasShadow = true
        self.view.layer?.masksToBounds = false
        self.view.shadow = NSShadow()
        self.invalidateShadow()
        
        // Make sure the view doesn't go away when the user clicks close
        self.isReleasedWhenClosed = false
    }
    
    func showWindow() {
        NSApp.activate(ignoringOtherApps: true)
        self.makeKeyAndOrderFront(nil)
        self.makeKey()
        self.orderFrontRegardless()
    }
    
    convenience init(contentRect: NSRect, display: Bool) {
        self.init()
        self.setFrame(contentRect, display: display)
    }
}
