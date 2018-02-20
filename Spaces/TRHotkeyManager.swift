//
//  TRHotkeyManager.swift
//  Spaces
//
//  Created by Tyler Reardon on 2/19/18.
//  Copyright © 2018 Tyler Reardon. All rights reserved.
//

import Foundation

class TRHotKeyManager{
    static let shared = TRHotKeyManager()
    private var hotkeyMap = [String: TRHotKey]()
    
    func createHotKey(keys:[String], modifiers:[String], action: @escaping () -> Void) -> TRHotKey {
        let identifier = self.getHashForShortcut(keys: keys, modifiers: modifiers)
        let hotkey = TRHotKey(characters: keys, modifiers: modifiers, identifier: identifier, action: action)
        self.hotkeyMap[identifier] = hotkey
        return hotkey
    }
    
    func removeHotKey(identifier: String) {
        if let hotkey = self.hotkeyMap[identifier] {
            hotkey.unregister()
            self.hotkeyMap[identifier] = nil
        }
    }
    
    private func getHashForShortcut(keys: [String], modifiers: [String]) -> String{
        var hashString = ""
        var combinedArray = keys
        combinedArray.append(contentsOf: modifiers)
        let sortedArray = combinedArray.sorted(by: <)
        for item in sortedArray{
            hashString += "\(item)_"
        }
        return hashString
    }
}
