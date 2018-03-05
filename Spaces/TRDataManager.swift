//
//  TRDataManager.swift
//  Spaces
//
//  Created by Tyler Reardon on 3/4/18.
//  Copyright © 2018 Tyler Reardon. All rights reserved.
//

import Foundation

class TRDataManager: TRManagerBase{
    static let shared = TRDataManager()
    let appDirectory = "\(NSHomeDirectory())/.spaces"
    
    override init() {
        super.init()
        self.createAppFolderIfNeeded()
        self.createAppFileIfNeeded()
    }
    
    func createAppFolderIfNeeded() {
        TRFileManager.shared.createDirectory(fullPath: appDirectory)
    }
    
    func createAppFileIfNeeded() {
        if (!TRFileManager.shared.fileExists(fullPath: "\(self.appDirectory)/config.json")) {
            TRFileManager.shared.writeFile(fullPath: "\(self.appDirectory)", fileName:"config.json", data:"{}")
        }
    }
}
