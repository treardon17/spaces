//
//  TRDataManager.swift
//  Spaces
//
//  Created by Tyler Reardon on 3/4/18.
//  Copyright © 2018 Tyler Reardon. All rights reserved.
//

import Foundation
import SwiftyJSON
import CloudKit

class TRConfigManager: TRManagerBase{
    static let shared = TRConfigManager()
    let appDirectory = "\(NSHomeDirectory())/.spacework"
    let configFileName = "config.json"
    var config:JSON!
    private var witnessListener:Witness?
    private var configListeners = [String:([FileEvent])->()]()
    private var notifyListeners = true
    
    private var _sizes = [String:TRWindowSize]()
    var sizes:[String:TRWindowSize] {
        get { return self._sizes }
    }
    
    var shortcuts:[JSON]{
        get{ return self.config["shortcuts"].arrayValue }
    }
    
    var configPath:String{
        get{ return "\(self.appDirectory)/\(self.configFileName)" }
    }
    
    override init() {
        super.init()
        self.setupConfig()
        self.listenToConfigChanges()
    }
    
    func setupConfig() {
        if (!TRFileManager.shared.fileExists(fullPath: self.configPath)) {
            self.config = self.getDefaultConfig()
            self.saveConfig()
        }
        self.loadConfig()
    }
    
    func createAppFolderIfNeeded() {
        TRFileManager.shared.createDirectory(fullPath: appDirectory)
    }
    
    func createAppFileIfNeeded() {
        if (!TRFileManager.shared.fileExists(fullPath: self.configPath)) {
            TRFileManager.shared.writeFile(fullPath: "\(self.appDirectory)", fileName:self.configFileName, data:self.getDefaultConfig().rawString()!)
        }
    }
    
    func saveConfig() {
        if let configString = config.rawString() {
            self.notifyListeners = false
            self.createAppFolderIfNeeded()
            self.createAppFileIfNeeded()
            TRFileManager.shared.writeFile(fullPath: "\(self.appDirectory)", fileName:self.configFileName, data:configString)
            self.notifyListeners = true
        }
    }
    
    func loadConfig() {
        if let existingConfig = TRFileManager.shared.getJSONFromFile(fullPath: self.configPath) {
            self.config = existingConfig
        } else {
            self.config = self.getDefaultConfig()
        }
        self.generateSizesFromConfig()
    }
    
    func listenToConfigChanges() {
        self.witnessListener = TRFileManager.shared.listenToFolder(fullPath: self.configPath) { (events) in
            self.setupConfig()
            self.alertConfigListeners(events: events)
        }
    }
    
    func addConfigListener(callback:@escaping ([FileEvent]) -> ()) -> String {
        let uuid = UUID().uuidString
        self.configListeners[uuid] = callback
        return uuid
    }
    
    func removeConfigListener(id:String) {
        self.configListeners[id] = nil
    }
    
    func alertConfigListeners(events:[FileEvent]) {
        if self.notifyListeners {
            for (_, value) in self.configListeners{
                value(events)
            }
        }
    }
    
    func getCGFloatFromJSON(json:JSON, nullable: Bool) -> CGFloat? {
        var returnVal:CGFloat? = nil
        if let val = json.double {
            returnVal = CGFloat(val)
        } else if nullable {
            returnVal = nil
        } else {
            returnVal = CGFloat(0)
        }
        return returnVal
    }
    
    func generateSizesFromConfig() {
        for (key, json) in self.config["sizes"] {
            let xProp = self.getCGFloatFromJSON(json: json["xProp"], nullable: false)!
            let yProp = self.getCGFloatFromJSON(json: json["yProp"], nullable: false)!
            let widthProp = self.getCGFloatFromJSON(json: json["widthProp"], nullable: true)
            let heightProp = self.getCGFloatFromJSON(json: json["heightProp"], nullable: true)
            let width = self.getCGFloatFromJSON(json: json["width"], nullable: true)
            let height = self.getCGFloatFromJSON(json: json["height"], nullable: true)
            let originX = self.getCGFloatFromJSON(json: json["originX"], nullable: false)!
            let originY = self.getCGFloatFromJSON(json: json["originY"], nullable: false)!
            let insetTop = self.getCGFloatFromJSON(json: json["insetTop"], nullable: false)!
            let insetBottom = self.getCGFloatFromJSON(json: json["insetBottom"], nullable: false)!
            let insetLeft = self.getCGFloatFromJSON(json: json["insetLeft"], nullable: false)!
            let insetRight = self.getCGFloatFromJSON(json: json["insetRight"], nullable: false)!
            let offsetX = self.getCGFloatFromJSON(json: json["offsetX"], nullable: false)!
            let offsetY = self.getCGFloatFromJSON(json: json["offsetY"], nullable: false)!
            
            self._sizes[key] = TRWindowSize(xProp: xProp, yProp: yProp, widthProp: widthProp, heightProp: heightProp, width: width, height: height, originX: originX, originY: originY, insetTop: insetTop, insetBottom: insetBottom, insetLeft: insetLeft, insetRight: insetRight, offsetX: offsetX, offsetY: offsetY)
        }
    }
    
    func addSizeToConfig(name:String, size:TRWindowSize, overwrite:Bool) -> Bool {
        if self.config["sizes"][name].dictionaryObject == nil || overwrite {
            self.config["sizes"][name] = size.getJSON()
            self._sizes[name] = size
            self.saveConfig()
            return true
        } else {
            return false
        }
    }
    
    func addShortcutToConfig(name:String, size:TRHotKey, overwrite:Bool) -> Bool {
        if self.config["shortcuts"][name].dictionaryObject == nil || overwrite {
            self.config["shortcuts"][name] = size.getJSON()
            self.saveConfig()
            return true
        } else {
            return false
        }
    }
    
    func getDefaultConfig() -> JSON {
        // SIZES
        var sizes:JSON = [:]
        let defaultInset:CGFloat = 25
        sizes["fullscreen"] = TRWindowSize(xProp: 0.5, yProp: 0.5, widthProp: 1, heightProp: 1, width: nil, height: nil, originX: 0.5, originY: 0.5, insetTop: 0, insetBottom: 0, insetLeft: 0, insetRight: 0, offsetX: 0, offsetY: 0).getJSON()
        sizes["fullscreenMargin"] = TRWindowSize(xProp: 0.5, yProp: 0.5, widthProp: 1, heightProp: 1, width: nil, height: nil, originX: 0.5, originY: 0.5, insetTop: defaultInset, insetBottom: defaultInset, insetLeft: defaultInset, insetRight: defaultInset, offsetX: 0, offsetY: 0).getJSON()
        sizes["halfLeft"] = TRWindowSize(xProp: 0, yProp: 0, widthProp: 0.5, heightProp: 1, width: nil, height: nil, originX: 0, originY: 0, insetTop: defaultInset, insetBottom: defaultInset, insetLeft: defaultInset, insetRight: defaultInset/2, offsetX: 0, offsetY: 0).getJSON()
        sizes["halfRight"] = TRWindowSize(xProp: 0.5, yProp: 0, widthProp: 0.5, heightProp: 1, width: nil, height: nil, originX: 0, originY: 0, insetTop: defaultInset, insetBottom: defaultInset, insetLeft: defaultInset/2, insetRight: defaultInset, offsetX: 0, offsetY: 0).getJSON()
        sizes["halfUp"] = TRWindowSize(xProp: 0, yProp: 0, widthProp: 1, heightProp: 0.5, width: nil, height: nil, originX: 0, originY: 0, insetTop: defaultInset, insetBottom: defaultInset/2, insetLeft: defaultInset, insetRight: defaultInset, offsetX: 0, offsetY: 0).getJSON()
        sizes["halfDown"] = TRWindowSize(xProp: 0, yProp: 0.5, widthProp: 1, heightProp: 0.5, width: nil, height: nil, originX: 0, originY: 0, insetTop: defaultInset/2, insetBottom: defaultInset, insetLeft: defaultInset, insetRight: defaultInset, offsetX: 0, offsetY: 0).getJSON()
        sizes["centered"] = TRWindowSize(xProp: 0.5, yProp: 0.5, widthProp: nil, heightProp: nil, width: nil, height: nil, originX: 0.5, originY: 0.5, insetTop: 0, insetBottom: 0, insetLeft: 0, insetRight: 0, offsetX: 0, offsetY: 0).getJSON()
        
        // SHORTCUTS
        let shortcuts:[JSON] = [
            TRHotKey(characters: ["enter"], modifiers: ["control", "option"], actionIdentifier: "fullscreen").getJSON(),
            TRHotKey(characters: ["'"], modifiers: ["control", "option"], actionIdentifier: "fullscreenMargin").getJSON(),
            TRHotKey(characters: ["left"], modifiers: ["control", "option"], actionIdentifier: "halfLeft").getJSON(),
            TRHotKey(characters: ["right"], modifiers: ["control", "option"], actionIdentifier: "halfRight").getJSON(),
            TRHotKey(characters: ["up"], modifiers: ["control", "option"], actionIdentifier: "halfUp").getJSON(),
            TRHotKey(characters: ["down"], modifiers: ["control", "option"], actionIdentifier: "halfDown").getJSON(),
            TRHotKey(characters: ["c"], modifiers: ["control", "option"], actionIdentifier: "centered").getJSON()
        ]
        
        // PUTTING IT ALL TOGETHER
        var defaultConfig:JSON = [:]
        defaultConfig["sizes"] = sizes
        defaultConfig["shortcuts"] = JSON(shortcuts)
        return defaultConfig
    }
}
