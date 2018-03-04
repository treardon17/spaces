//
//  HotKeyManager.swift
//  Spaces
//
//  Created by Tyler Reardon on 7/26/17.
//  Copyright © 2017 Tyler Reardon. All rights reserved.
//

import Foundation
import Magnet

class TRHotKey: NSObject{
    var action: (() -> Void)?
    var identifier: String!
    var hotkey: HotKey?
    
    init(characters: [String], modifiers: [String], identifier: String, action: @escaping ()->Void){
        super.init()
        self.registerShortcut(characters: characters, modifiers: modifiers, identifier: identifier, action: action)
       
//        self.registerShortcut(characters: ["c"], modifiers: ["command", "control"]) {
//            print("it works!!!!!")
//        }
    }
    
    /// Takes a list of characters and modifiers and completes the callback when those keys are pressed.
    ///     Note: non-visible characters such as space, option, command, arrows, are spelled out
    private func registerShortcut(characters: [String], modifiers: [String], identifier: String, action: @escaping ()->Void){
        var keys:Int?
        var mods:NSEvent.ModifierFlags?
        self.action = action
        
        for char in characters{
            if var keys = keys{
                keys = keys + self.codeForCharacter(char: char)
            }else{
                keys = self.codeForCharacter(char: char)
            }
        }
        
        for mod in modifiers{
            if (mods != nil){
                mods = NSEvent.ModifierFlags(rawValue: NSEvent.ModifierFlags.RawValue(Float(mods!.rawValue) + Float(self.codeForModifier(mod: mod).rawValue)))
            }else{
                mods = self.codeForModifier(mod: mod)
            }
        }
        
        self.identifier = identifier
        if let keys = keys, let mods = mods{
            if let keyCombo = KeyCombo(keyCode: keys, cocoaModifiers: mods) {
                self.hotkey = HotKey(identifier: self.identifier, keyCombo: keyCombo, target: self, action: #selector(self.handleShortcut))
                self.hotkey!.register()
            }
        }
    }
    
    @objc private func handleShortcut() {
        if let action = self.action{
            action()
        }
    }
    
    func unregister() {
        if let hotkey = self.hotkey{
            hotkey.unregister()
        } else {
            print("Could not unregister hotkey")
        }
    }
    
    func codeForModifier(mod: String) -> NSEvent.ModifierFlags{
        switch mod {
        case "command":
            return NSEvent.ModifierFlags.command
        case "option":
            return NSEvent.ModifierFlags.option
        case "control":
            return NSEvent.ModifierFlags.control
        case "shift":
            return NSEvent.ModifierFlags.shift
        default:
            return NSEvent.ModifierFlags.shift
        }
    }
    
    func codeForCharacter(char: String) -> Int{
        switch char {
        case "'":
            return Int(Keycode.apostrophe)
        case "0":
            return Int(Keycode.zero)
        case "1":
            return Int(Keycode.one)
        case "2":
            return Int(Keycode.two)
        case "3":
            return Int(Keycode.three)
        case "4":
            return Int(Keycode.four)
        case "5":
            return Int(Keycode.five)
        case "6":
            return Int(Keycode.six)
        case "7":
            return Int(Keycode.seven)
        case "8":
            return Int(Keycode.eight)
        case "9":
            return Int(Keycode.nine)
        case "a":
            return Int(Keycode.a)
        case "b":
            return Int(Keycode.b)
        case "c":
            return Int(Keycode.c)
        case "d":
            return Int(Keycode.d)
        case "e":
            return Int(Keycode.e)
        case "f":
            return Int(Keycode.f)
        case "g":
            return Int(Keycode.g)
        case "h":
            return Int(Keycode.h)
        case "i":
            return Int(Keycode.i)
        case "j":
            return Int(Keycode.j)
        case "k":
            return Int(Keycode.k)
        case "l":
            return Int(Keycode.l)
        case "m":
            return Int(Keycode.m)
        case "n":
            return Int(Keycode.n)
        case "o":
            return Int(Keycode.o)
        case "p":
            return Int(Keycode.p)
        case "q":
            return Int(Keycode.q)
        case "r":
            return Int(Keycode.r)
        case "s":
            return Int(Keycode.s)
        case "t":
            return Int(Keycode.t)
        case "u":
            return Int(Keycode.u)
        case "v":
            return Int(Keycode.v)
        case "w":
            return Int(Keycode.w)
        case "x":
            return Int(Keycode.x)
        case "y":
            return Int(Keycode.y)
        case "z":
            return Int(Keycode.z)
        case "space":
            return Int(Keycode.space)
        case "enter":
            return Int(Keycode.returnKey)
        case "up":
            return Int(Keycode.upArrow)
        case "down":
            return Int(Keycode.downArrow)
        case "left":
            return Int(Keycode.leftArrow)
        case "right":
            return Int(Keycode.rightArrow)
        case "]":
            return Int(Keycode.rightBracket)
        case "[":
            return Int(Keycode.leftBracket)
        case "f1":
            return Int(Keycode.f1)
        case "f2":
            return Int(Keycode.f2)
        case "f3":
            return Int(Keycode.f3)
        case "f4":
            return Int(Keycode.f4)
        case "f5":
            return Int(Keycode.f5)
        case "f6":
            return Int(Keycode.f6)
        case "f7":
            return Int(Keycode.f7)
        case "f8":
            return Int(Keycode.f8)
        case "f9":
            return Int(Keycode.f9)
        default:
            return 0
        }
    }
}

struct Keycode {
    
    // Layout-independent Keys
    // eg.These key codes are always the same key on all layouts.
    static let returnKey                 : UInt16 = 0x24
    static let enter                     : UInt16 = 0x4C
    static let tab                       : UInt16 = 0x30
    static let space                     : UInt16 = 0x31
    static let delete                    : UInt16 = 0x33
    static let escape                    : UInt16 = 0x35
    static let command                   : UInt16 = 0x37
    static let shift                     : UInt16 = 0x38
    static let capsLock                  : UInt16 = 0x39
    static let option                    : UInt16 = 0x3A
    static let control                   : UInt16 = 0x3B
    static let rightShift                : UInt16 = 0x3C
    static let rightOption               : UInt16 = 0x3D
    static let rightControl              : UInt16 = 0x3E
    static let leftArrow                 : UInt16 = 0x7B
    static let rightArrow                : UInt16 = 0x7C
    static let downArrow                 : UInt16 = 0x7D
    static let upArrow                   : UInt16 = 0x7E
    static let volumeUp                  : UInt16 = 0x48
    static let volumeDown                : UInt16 = 0x49
    static let mute                      : UInt16 = 0x4A
    static let help                      : UInt16 = 0x72
    static let home                      : UInt16 = 0x73
    static let pageUp                    : UInt16 = 0x74
    static let forwardDelete             : UInt16 = 0x75
    static let end                       : UInt16 = 0x77
    static let pageDown                  : UInt16 = 0x79
    static let function                  : UInt16 = 0x3F
    static let f1                        : UInt16 = 0x7A
    static let f2                        : UInt16 = 0x78
    static let f4                        : UInt16 = 0x76
    static let f5                        : UInt16 = 0x60
    static let f6                        : UInt16 = 0x61
    static let f7                        : UInt16 = 0x62
    static let f3                        : UInt16 = 0x63
    static let f8                        : UInt16 = 0x64
    static let f9                        : UInt16 = 0x65
    static let f10                       : UInt16 = 0x6D
    static let f11                       : UInt16 = 0x67
    static let f12                       : UInt16 = 0x6F
    static let f13                       : UInt16 = 0x69
    static let f14                       : UInt16 = 0x6B
    static let f15                       : UInt16 = 0x71
    static let f16                       : UInt16 = 0x6A
    static let f17                       : UInt16 = 0x40
    static let f18                       : UInt16 = 0x4F
    static let f19                       : UInt16 = 0x50
    static let f20                       : UInt16 = 0x5A
    
    // US-ANSI Keyboard Positions
    // eg. These key codes are for the physical key (in any keyboard layout)
    // at the location of the named key in the US-ANSI layout.
    static let a                         : UInt16 = 0x00
    static let b                         : UInt16 = 0x0B
    static let c                         : UInt16 = 0x08
    static let d                         : UInt16 = 0x02
    static let e                         : UInt16 = 0x0E
    static let f                         : UInt16 = 0x03
    static let g                         : UInt16 = 0x05
    static let h                         : UInt16 = 0x04
    static let i                         : UInt16 = 0x22
    static let j                         : UInt16 = 0x26
    static let k                         : UInt16 = 0x28
    static let l                         : UInt16 = 0x25
    static let m                         : UInt16 = 0x2E
    static let n                         : UInt16 = 0x2D
    static let o                         : UInt16 = 0x1F
    static let p                         : UInt16 = 0x23
    static let q                         : UInt16 = 0x0C
    static let r                         : UInt16 = 0x0F
    static let s                         : UInt16 = 0x01
    static let t                         : UInt16 = 0x11
    static let u                         : UInt16 = 0x20
    static let v                         : UInt16 = 0x09
    static let w                         : UInt16 = 0x0D
    static let x                         : UInt16 = 0x07
    static let y                         : UInt16 = 0x10
    static let z                         : UInt16 = 0x06
    
    static let zero                      : UInt16 = 0x1D
    static let one                       : UInt16 = 0x12
    static let two                       : UInt16 = 0x13
    static let three                     : UInt16 = 0x14
    static let four                      : UInt16 = 0x15
    static let five                      : UInt16 = 0x17
    static let six                       : UInt16 = 0x16
    static let seven                     : UInt16 = 0x1A
    static let eight                     : UInt16 = 0x1C
    static let nine                      : UInt16 = 0x19
    
    static let equals                    : UInt16 = 0x18
    static let minus                     : UInt16 = 0x1B
    static let semicolon                 : UInt16 = 0x29
    static let apostrophe                : UInt16 = 0x27
    static let comma                     : UInt16 = 0x2B
    static let period                    : UInt16 = 0x2F
    static let forwardSlash              : UInt16 = 0x2C
    static let backslash                 : UInt16 = 0x2A
    static let grave                     : UInt16 = 0x32
    static let leftBracket               : UInt16 = 0x21
    static let rightBracket              : UInt16 = 0x1E
    
    static let keypadDecimal             : UInt16 = 0x41
    static let keypadMultiply            : UInt16 = 0x43
    static let keypadPlus                : UInt16 = 0x45
    static let keypadClear               : UInt16 = 0x47
    static let keypadDivide              : UInt16 = 0x4B
    static let keypadEnter               : UInt16 = 0x4C
    static let keypadMinus               : UInt16 = 0x4E
    static let keypadEquals              : UInt16 = 0x51
    static let keypad0                   : UInt16 = 0x52
    static let keypad1                   : UInt16 = 0x53
    static let keypad2                   : UInt16 = 0x54
    static let keypad3                   : UInt16 = 0x55
    static let keypad4                   : UInt16 = 0x56
    static let keypad5                   : UInt16 = 0x57
    static let keypad6                   : UInt16 = 0x58
    static let keypad7                   : UInt16 = 0x59
    static let keypad8                   : UInt16 = 0x5B
    static let keypad9                   : UInt16 = 0x5C
}
