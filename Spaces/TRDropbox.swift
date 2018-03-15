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
    func registerDropbox() {
        if (DropboxOAuthManager.sharedOAuthManager == nil) {
            DropboxClientsManager.setupWithAppKeyDesktop("slfx4exzmjw6sjf")
            NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(handleGetURLEvent), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
        }
    }
    
    func loginDropbox(controller:NSViewController) {
        DropboxClientsManager.authorizeFromController(sharedWorkspace: NSWorkspace.shared, controller: controller, openURL: { (url: URL) -> Void in NSWorkspace.shared.open(url)
        })
    }
    
    @objc func handleGetURLEvent(_ event: NSAppleEventDescriptor?, replyEvent: NSAppleEventDescriptor?) {
        if let aeEventDescriptor = event?.paramDescriptor(forKeyword: AEKeyword(keyDirectObject)) {
            if let urlStr = aeEventDescriptor.stringValue {
                let url = URL(string: urlStr)!
                if let authResult = DropboxClientsManager.handleRedirectURL(url) {
                    switch authResult {
                    case .success:
                        print("Success! User is logged into Dropbox.")
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
