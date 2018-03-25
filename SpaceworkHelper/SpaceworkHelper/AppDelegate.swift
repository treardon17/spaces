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
        if NSRunningApplication.runningApplications(withBundleIdentifier: "com.rockrabbit.Spacework").isEmpty {
            NSWorkspace.shared.launchApplication("Spacework")
        }
        NSApp.terminate(nil)
    }
}

