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
    var config:JSON = [:]
    
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
            TRFileManager.shared.writeFile(fullPath: "\(self.appDirectory)", fileName:self.configFileName, data:"{}")
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
        }
    }
}
