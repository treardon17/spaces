//
//  TRStatusBarManager.swift
//  Spaces
//
//  Created by Tyler Reardon on 3/14/18.
//  Copyright © 2018 Tyler Reardon. All rights reserved.
//

import Foundation
import Cocoa

class TRStatusBarManager:TRManagerBase {
    static let shared:TRStatusBarManager = TRStatusBarManager()
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    
    func setupMenu() {
        self.initButton()
        
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Print Quote", action: #selector(self.printQuote(_:)), keyEquivalent: "P"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit Spacework", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
    
    func initButton() {
        if let button = self.statusItem.button {
            let image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
            let imageWidth = image?.size.width
            let imageHeight = image?.size.height
            let imageProp = imageHeight! / imageWidth!
            let newImageWidth:CGFloat = 20
            let newImageHeight = newImageWidth * imageProp
            button.image = image
            button.image?.size = NSSize(width: newImageWidth, height: newImageHeight)
            button.action = #selector(printQuote(_:))
            button.target = self
        }
    }

    @objc func printQuote(_ sender: Any?) {
        let quoteText = "Never put off until tomorrow what you can do the day after tomorrow."
        let quoteAuthor = "Mark Twain"

        print("\(quoteText) — \(quoteAuthor)")
    }
}
