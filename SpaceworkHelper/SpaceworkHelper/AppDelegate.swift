//
//  AppDelegate.swift
//  SpaceworkHelper
//
//  Created by Tyler Reardon on 3/18/18.
//  Copyright © 2018 Tyler Reardon. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        var path = "../../../../\(Bundle.main.bundlePath)"
        NSWorkspace.shared.launchApplication(path)
        NSApp.terminate(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

