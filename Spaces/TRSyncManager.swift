//
//  SyncManager.swift
//  Spaces
//
//  Created by Tyler Reardon on 3/14/18.
//  Copyright © 2018 Tyler Reardon. All rights reserved.
//

import Foundation
import SwiftyDropbox

class TRSyncManager: TRManagerBase {
    static let shared:TRSyncManager = TRSyncManager()
    let dropbox = TRDropbox()
    
    override init() {
        super.init()
        self.setupSync()
    }
    
    func setupSync() {
        self.dropbox.registerDropbox()
        self.dropbox.loginDropbox()
    }
}
