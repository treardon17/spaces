//
//  AppDelegate.swift
//  Spaces
//
//  Created by Tyler Reardon on 7/25/17.
//  Copyright © 2017 Tyler Reardon. All rights reserved.
//

import Cocoa
import Silica
import SwiftyDropbox

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    var darkModeOn:Bool = true;
    var window:TROverlayWindow? = nil;

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        _ = TRWindowManager.shared
        _ = TRConfigManager.shared
        TRSyncManager.shared.setupSync()
        
        if let button = statusItem.button {
            let image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
            let imageWidth = image?.size.width
            let imageHeight = image?.size.height
            let imageProp = imageHeight! / imageWidth!
            let newImageWidth:CGFloat = 20
            let newImageHeight = newImageWidth * imageProp
            button.image = image
            button.image?.size = NSSize(width: newImageWidth, height: newImageHeight)
            button.action = #selector(printQuote(_:))
        }
    }
    
    @objc func printQuote(_ sender: Any?) {
        let quoteText = "Never put off until tomorrow what you can do the day after tomorrow."
        let quoteAuthor = "Mark Twain"
        
        print("\(quoteText) — \(quoteAuthor)")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

