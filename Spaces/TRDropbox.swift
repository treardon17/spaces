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
    let window = TRWindow()
    
    override init() {
        super.init()
        
        let button = NSButton()
        window.view.addSubview(button)
        button.autoCenterInSuperview()
        button.setFrameSize(NSSize(width: 200, height: 75))
        button.title = "Enable Dropbox"
        button.action = #selector(loginDropbox)
        button.target = self
    }
    
    func registerDropbox() {
        if (DropboxOAuthManager.sharedOAuthManager == nil) {
            DropboxClientsManager.setupWithAppKeyDesktop("slfx4exzmjw6sjf")
            NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(handleGetURLEvent), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
        }
    }
    
    @objc func loginDropbox() {
        DropboxClientsManager.authorizeFromController(sharedWorkspace: NSWorkspace.shared, controller: self.window.contentViewController, openURL: { (url: URL) -> Void in NSWorkspace.shared.open(url)
        })
    }
    
    func showLoginWindow() {
        self.window.showWindow()
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
