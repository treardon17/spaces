//
//  TRSettingsManager.swift
//  Spacework
//
//  Created by Tyler Reardon on 3/21/18.
//  Copyright © 2018 Tyler Reardon. All rights reserved.
//

import Foundation
import ServiceManagement

class TRSettingsManager: TRManagerBase{
    static let shared:TRSettingsManager = TRSettingsManager()
    let helperBundleIdentifier = "rockrabbit.SpaceworkHelper"
    var loginItemUserDefaultKey:String!
    
    override init() {
        super.init()
        self.loginItemUserDefaultKey = "loginEnabled.\(self.helperBundleIdentifier)"
    }
    
    var loginAtStartupEnabled:Bool {
        get{
            var enabled = false
            if let savedValue = UserDefaults.standard.value(forKey: self.loginItemUserDefaultKey) as? Bool {
                enabled = savedValue
            }
            return enabled
        }
    }
    
    func setLoginStartup(enabled: Bool) {
        if (!SMLoginItemSetEnabled(self.helperBundleIdentifier as CFString, enabled)) {
            print("Login at startup unsuccessful")
        } else {
            UserDefaults.standard.set(enabled, forKey: self.loginItemUserDefaultKey)
        }
    }
}
