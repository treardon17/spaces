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
    
    func write(text: String, to fileNamed: String, folder: String = "SavedFiles") {
        guard let path = NSSearchPathForDirectoriesInDomains(.downloadsDirectory, .userDomainMask, true).first else { return }
        guard let writePath = NSURL(fileURLWithPath: path).appendingPathComponent(folder) else { return }
        try? FileManager.default.createDirectory(atPath: writePath.path, withIntermediateDirectories: true)
        let file = writePath.appendingPathComponent(fileNamed + ".txt")
        try? text.write(to: file, atomically: false, encoding: String.Encoding.utf8)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let directory = FileManager.default.currentDirectoryPath
        let string = "directory: \(directory))\nbundle: \(Bundle.main.bundleIdentifier!)\nsuccess: \(NSWorkspace.shared.launchApplication("Spacework"))"
        self.write(text: string, to: "log", folder: "spacework_logs")
        NSApp.terminate(nil)
    }
}

