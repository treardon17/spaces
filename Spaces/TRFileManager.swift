//
//  FileManager.swift
//  Spaces
//
//  Created by Tyler Reardon on 3/4/18.
//  Copyright © 2018 Tyler Reardon. All rights reserved.
//

import Foundation

class TRFileManager {
    static let shared = FileManager()
    
    func folderExists(fullPath:String) {
        let fileManager = FileManager.default
        var isDir : ObjCBool = false
        if fileManager.fileExists(atPath: fullPath, isDirectory:&isDir) {
            if isDir.boolValue {
                // file exists and is a directory
            } else {
                // file exists and is not a directory
            }
        } else {
            // file does not exist
        }
    }
}
