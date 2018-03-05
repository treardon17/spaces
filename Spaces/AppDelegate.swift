//
//  AppDelegate.swift
//  Spaces
//
//  Created by Tyler Reardon on 7/25/17.
//  Copyright © 2017 Tyler Reardon. All rights reserved.
//

import Cocoa
import Silica

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem:NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength);
    var darkModeOn:Bool = true;
    var window:TROverlayWindow? = nil;

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        _ = TRWindowManager.shared
        _ = TRDataManager.shared
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

