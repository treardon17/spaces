//
//  TRSettingsManager.swift
//  Spacework
//
//  Created by Tyler Reardon on 3/21/18.
//  Copyright © 2018 Tyler Reardon. All rights reserved.
//

import Foundation
import ServiceManagement

class TRSettingsManager{
    static let shared:TRSettingsManager = TRSettingsManager()
    let loginItemUserDefaultKey = "loginEnabled"
    
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
        if (!SMLoginItemSetEnabled("rockrabbit.SpaceworkHelper" as CFString, enabled)) {
            print("Login at startup unsuccessful")
        } else {
            UserDefaults.standard.set(enabled, forKey: self.loginItemUserDefaultKey)
        }
    }
}
