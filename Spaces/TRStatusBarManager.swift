//
//  TRStatusBarManager.swift
//  Spaces
//
//  Created by Tyler Reardon on 3/14/18.
//  Copyright © 2018 Tyler Reardon. All rights reserved.
//

import Foundation
import Cocoa
import SwiftyDropbox

class TRStatusBarManager:TRManagerBase {
    static let shared:TRStatusBarManager = TRStatusBarManager()
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    var dropboxMenuItem:NSMenuItem?
    var loginMenuItem:NSMenuItem?
    var quitMenuItem:NSMenuItem?
    
    func setupMenu() {
        self.initButton()
        
        let menu = NSMenu()
        
        // DROPBOX LOGIN
        self.dropboxMenuItem = NSMenuItem(title: "Dropbox sign in", action: #selector(dropboxSignIn(_:)), keyEquivalent: "")
        self.dropboxMenuItem!.target = self
        menu.addItem(self.dropboxMenuItem!)
        
        menu.addItem(NSMenuItem.separator())
        let loginTitle = TRSettingsManager.shared.loginAtStartupEnabled ? "Run at startup" : "Disable run at start"
        self.loginMenuItem = NSMenuItem(title: loginTitle, action: #selector(toggleStartupLogin(_:)), keyEquivalent: "")
        self.loginMenuItem!.target = self
        menu.addItem(self.loginMenuItem!)
        
        // QUIT
        menu.addItem(NSMenuItem.separator())
        self.quitMenuItem = NSMenuItem(title: "Quit Spacework", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        menu.addItem(self.quitMenuItem!)
        
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
            button.target = self
        }
    }
    
    @objc func toggleStartupLogin(_ sender: Any?) {
        TRSettingsManager.shared.setLoginStartup(enabled: !TRSettingsManager.shared.loginAtStartupEnabled)
        let loginTitle = TRSettingsManager.shared.loginAtStartupEnabled ? "Run at startup" : "Disable run at start"
        self.loginMenuItem!.title = loginTitle
    }

    @objc func dropboxSignIn(_ sender: Any?) {
        print("Signing into Dropbox")
        TRSyncManager.shared.setupSync()
    }
}
