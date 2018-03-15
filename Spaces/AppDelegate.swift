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
    // Managers
    let windowManager = TRWindowManager.shared
    let configManager = TRConfigManager.shared
    let syncManager = TRSyncManager.shared
    let statusBarManager = TRStatusBarManager.shared
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.syncManager.setupSync()
        self.statusBarManager.setupMenu()
    }

    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

