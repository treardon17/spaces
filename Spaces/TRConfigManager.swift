//
//  TRDataManager.swift
//  Spaces
//
//  Created by Tyler Reardon on 3/4/18.
//  Copyright © 2018 Tyler Reardon. All rights reserved.
//

import Foundation
import SwiftyJSON

class TRConfigManager: TRManagerBase{
    static let shared = TRConfigManager()
    let appDirectory = "\(NSHomeDirectory())/.spaces"
    let configFileName = "config.json"
    var config:JSON!
    
    var configPath:String{
        get{ return "\(self.appDirectory)/\(self.configFileName)" }
    }
    
    override init() {
        super.init()
        self.createAppFolderIfNeeded()
        self.createAppFileIfNeeded()
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
            TRFileManager.shared.writeFile(fullPath: "\(self.appDirectory)", fileName:self.configFileName, data:configString)
        }
    }
    
    func loadConfig() {
        if let existingConfig = TRFileManager.shared.getJSONFromFile(fullPath: self.configPath) {
            self.config = existingConfig
        } else {
            self.config = self.getDefaultConfig()
        }
    }
    
    func createJSONSizeConfig(xProp:CGFloat, yProp:CGFloat, widthProp:CGFloat?, heightProp:CGFloat?, width:CGFloat?, height:CGFloat?, originX:CGFloat, originY:CGFloat, insetTop:CGFloat, insetBottom:CGFloat, insetLeft:CGFloat, insetRight:CGFloat, offsetX:CGFloat, offsetY:CGFloat) -> JSON {
        var config = JSON([
            "xProp": xProp,
            "yProp": yProp,
            "originX": originX,
            "originY": originY,
            "insetTop": insetTop,
            "insetBottom": insetBottom,
            "insetLeft": insetLeft,
            "insetRight": insetRight,
            "offsetX": offsetX,
            "offsetY": offsetY
        ])

        if let widthProp = widthProp { config["widthProp"].double = Double(widthProp) }
        if let heightProp = heightProp { config["heightProp"].double = Double(heightProp) }
        if let width = width { config["width"].double = Double(width) }
        if let height = height { config["height"].double = Double(height) }
        
        return config
    }
    
    func getDefaultConfig() -> JSON {
        var sizes:JSON = [:]
        let defaultInset:CGFloat = 25
        sizes["fullscreen"] = self.createJSONSizeConfig(xProp: 0.5, yProp: 0.5, widthProp: 1, heightProp: 1, width: nil, height: nil, originX: 0.5, originY: 0.5, insetTop: 0, insetBottom: 0, insetLeft: 0, insetRight: 0, offsetX: 0, offsetY: 0)
        sizes["fullscreenMargin"] = self.createJSONSizeConfig(xProp: 0.5, yProp: 0.5, widthProp: 1, heightProp: 1, width: nil, height: nil, originX: 0.5, originY: 0.5, insetTop: defaultInset, insetBottom: defaultInset, insetLeft: defaultInset, insetRight: defaultInset, offsetX: 0, offsetY: 0)
        sizes["halfLeft"] = self.createJSONSizeConfig(xProp: 0, yProp: 0, widthProp: 0.5, heightProp: 1, width: nil, height: nil, originX: 0, originY: 0, insetTop: defaultInset, insetBottom: defaultInset, insetLeft: defaultInset, insetRight: defaultInset/2, offsetX: 0, offsetY: 0)
        sizes["halfRight"] = self.createJSONSizeConfig(xProp: 0.5, yProp: 0, widthProp: 0.5, heightProp: 1, width: nil, height: nil, originX: 0, originY: 0, insetTop: defaultInset, insetBottom: defaultInset, insetLeft: defaultInset/2, insetRight: defaultInset, offsetX: 0, offsetY: 0)
        sizes["halfUp"] = self.createJSONSizeConfig(xProp: 0, yProp: 0, widthProp: 1, heightProp: 0.5, width: nil, height: nil, originX: 0, originY: 0, insetTop: defaultInset, insetBottom: defaultInset/2, insetLeft: defaultInset, insetRight: defaultInset, offsetX: 0, offsetY: 0)
        sizes["halfDown"] = self.createJSONSizeConfig(xProp: 0, yProp: 0.5, widthProp: 1, heightProp: 0.5, width: nil, height: nil, originX: 0, originY: 0, insetTop: defaultInset/2, insetBottom: defaultInset, insetLeft: defaultInset, insetRight: defaultInset, offsetX: 0, offsetY: 0)
        sizes["centered"] = self.createJSONSizeConfig(xProp: 0.5, yProp: 0.5, widthProp: nil, heightProp: nil, width: nil, height: nil, originX: 0.5, originY: 0.5, insetTop: 0, insetBottom: 0, insetLeft: 0, insetRight: 0, offsetX: 0, offsetY: 0)
        
        var defaultConfig:JSON = [:]
        defaultConfig["sizes"] = sizes
        return defaultConfig
    }
}
