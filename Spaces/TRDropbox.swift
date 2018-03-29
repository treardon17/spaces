//
//  TRDropbox.swift
//  Spaces
//
//  Created by Tyler Reardon on 3/14/18.
//  Copyright © 2018 Tyler Reardon. All rights reserved.
//

import Foundation
import SwiftyDropbox

class TRDropbox: NSObject {
//    let newWindow = NSWindow(contentRect: NSMakeRect(0, 0, NSScreen.main!.frame.midX, NSScreen.main!.frame.midY), styleMask: [.closable, .fullSizeContentView, .titled, .miniaturizable, .fullScreen], backing: .buffered, defer: false)
    let newWindow = TRWindow()
    
    func registerDropbox() {
        if (DropboxOAuthManager.sharedOAuthManager == nil) {
            DropboxClientsManager.setupWithAppKeyDesktop("slfx4exzmjw6sjf")
            NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(handleGetURLEvent), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
        }
    }
    
    func loginDropbox() {
//        let viewController = NSViewController()
//        DropboxClientsManager.authorizeFromController(sharedWorkspace: NSWorkspace.shared, controller: viewController, openURL: { (url: URL) -> Void in NSWorkspace.shared.open(url)
//        })
        
        self.newWindow.showWindow()

//        newWindow.title = "New Window"
//        newWindow.isOpaque = false
//        newWindow.center()
//        newWindow.isMovableByWindowBackground = true
//        newWindow.backgroundColor = NSColor.white
//        newWindow.makeKeyAndOrderFront(nil)
    }
    
    @objc func handleGetURLEvent(_ event: NSAppleEventDescriptor?, replyEvent: NSAppleEventDescriptor?) {
        if let aeEventDescriptor = event?.paramDescriptor(forKeyword: AEKeyword(keyDirectObject)) {
            if let urlStr = aeEventDescriptor.stringValue {
                let url = URL(string: urlStr)!
                if let authResult = DropboxClientsManager.handleRedirectURL(url) {
                    switch authResult {
                    case .success:
                        print("Success! User is logged into Dropbox.", DropboxOAuthManager.sharedOAuthManager.getAllAccessTokens())
                    case .cancel:
                        print("Authorization flow was manually canceled by user!")
                    case .error(_, let description):
                        print("Error: \(description)")
                    }
                }
                // this brings your application back the foreground on redirect
                NSApp.activate(ignoringOtherApps: true)
            }
        }
    }
}
