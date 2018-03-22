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
        var path:NSString = Bundle.main.bundlePath as NSString
        path = path.deletingLastPathComponent as NSString
        path = path.deletingLastPathComponent as NSString
        path = path.deletingLastPathComponent as NSString
        path = path.deletingLastPathComponent as NSString
        NSWorkspace.shared.launchApplication(path as String)
        NSApp.terminate(nil)
    }
}

