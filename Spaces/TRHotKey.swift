//
//  HotKeyManager.swift
//  Spaces
//
//  Created by Tyler Reardon on 7/26/17.
//  Copyright © 2017 Tyler Reardon. All rights reserved.
//

import Foundation
import Magnet
//import MASShortcut

class TRHotKey: NSObject{
//    var shortcuts = Set<MASShortcut>()
    private var shortcutClosures = [() -> ()]()
    
    override init(){
        super.init()
       
//        self.registerShortcut(characters: ["k"], modifiers: ["shift", "command"]) { 
//            print("it works!")
//        }
    }
    
    /// Takes a list of characters and modifiers and completes the callback when those keys are pressed.
    ///     Note: non-visible characters such as space, option, command, arrows, are spelled out
    func registerShortcut(characters: [String], modifiers: [String], callback: @escaping ()->Void){
        var keys:Int?
        var mods:UInt?
        
        for char in characters{
            if var keys = keys{
                keys = keys + self.codeForCharacter(char: char)
            }else{
                keys = self.codeForCharacter(char: char)
            }
        }
        
        for mod in modifiers{
            if (mods != nil){
                mods = UInt(mods! + self.codeForModifier(mod: mod))
            }else{
                mods = self.codeForModifier(mod: mod)
            }
        }
        
        self.shortcutClosures.append(callback)
        
        if let keyCombo = KeyCombo(keyCode: 11, carbonModifiers: 4352) {
            let hotKey = HotKey(identifier: "CommandControlB", keyCombo: keyCombo, target: self, action: #selector(self.handleShortcut))
            hotKey.register()
        }
        
//        let shortcut = MASShortcut.init(keyCode: UInt(keys!), modifierFlags: mods!)
//        if let shortcut = shortcut{
//            self.shortcuts.insert(shortcut)
//            MASShortcutMonitor.shared().register(shortcut, withAction: {
//                callback()
//            })
//        }else{
//            Logger.error("Could not create shortcut")
//        }
    }
    
    @objc func handleShortcut() {
        if self.shortcutClosures.count > 0 {
            let callback = self.shortcutClosures.remove(at: 0)
            callback()
        }
    }
    
//    func removeShortcut(shortcut: MASShortcut){
//        MASShortcutMonitor.shared().unregisterShortcut(shortcut)
//        self.shortcuts.remove(shortcut)
//    }
    
    func codeForModifier(mod: String) -> UInt{
//        switch mod {
//        case "command":
//            return NSEventModifierFlags.command.rawValue
//        case "option":
//            return NSEventModifierFlags.option.rawValue
//        case "control":
//            return NSEventModifierFlags.control.rawValue
//        case "shift":
//            return NSEventModifierFlags.shift.rawValue
//        default:
//            return UInt(0)
//        }
        return UInt(0)
    }
    
    func codeForCharacter(char: String) -> Int{
//        switch char {
//        case "0":
//            return kVK_ANSI_0
//        case "1":
//            return kVK_ANSI_1
//        case "2":
//            return kVK_ANSI_2
//        case "3":
//            return kVK_ANSI_3
//        case "4":
//            return kVK_ANSI_4
//        case "5":
//            return kVK_ANSI_5
//        case "6":
//            return kVK_ANSI_6
//        case "7":
//            return kVK_ANSI_7
//        case "8":
//            return kVK_ANSI_8
//        case "9":
//            return kVK_ANSI_9
//        case "a":
//            return kVK_ANSI_A
//        case "b":
//            return kVK_ANSI_B
//        case "c":
//            return kVK_ANSI_C
//        case "d":
//            return kVK_ANSI_D
//        case "e":
//            return kVK_ANSI_E
//        case "f":
//            return kVK_ANSI_F
//        case "g":
//            return kVK_ANSI_G
//        case "h":
//            return kVK_ANSI_H
//        case "i":
//            return kVK_ANSI_I
//        case "j":
//            return kVK_ANSI_J
//        case "k":
//            return kVK_ANSI_K
//        case "l":
//            return kVK_ANSI_L
//        case "m":
//            return kVK_ANSI_M
//        case "n":
//            return kVK_ANSI_N
//        case "o":
//            return kVK_ANSI_O
//        case "p":
//            return kVK_ANSI_P
//        case "q":
//            return kVK_ANSI_Q
//        case "r":
//            return kVK_ANSI_R
//        case "s":
//            return kVK_ANSI_S
//        case "t":
//            return kVK_ANSI_T
//        case "u":
//            return kVK_ANSI_U
//        case "v":
//            return kVK_ANSI_V
//        case "w":
//            return kVK_ANSI_W
//        case "x":
//            return kVK_ANSI_X
//        case "y":
//            return kVK_ANSI_Y
//        case "z":
//            return kVK_ANSI_Z
//        case "space":
//            return kVK_Space
//        case "enter":
//            return kVK_Return
//        case "up":
//            return kVK_UpArrow
//        case "down":
//            return kVK_DownArrow
//        case "left":
//            return kVK_LeftArrow
//        case "right":
//            return kVK_RightArrow
//        case "]":
//            return kVK_ANSI_RightBracket
//        case "[":
//            return kVK_ANSI_LeftBracket
//        case "f1":
//            return kVK_F1
//        case "f2":
//            return kVK_F2
//        case "f3":
//            return kVK_F3
//        case "f4":
//            return kVK_F4
//        case "f5":
//            return kVK_F5
//        case "f6":
//            return kVK_F6
//        case "f7":
//            return kVK_F7
//        case "f8":
//            return kVK_F8
//        case "f9":
//            return kVK_F9
//        default:
//            return 0
//        }
        return 0
    }
}
