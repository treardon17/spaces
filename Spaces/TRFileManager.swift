//
//  FileManager.swift
//  Spaces
//
//  Created by Tyler Reardon on 3/4/18.
//  Copyright © 2018 Tyler Reardon. All rights reserved.
//

import Foundation
import SwiftyJSON

class TRFileManager: TRManagerBase {
    static let shared = TRFileManager()
    
    enum Filestatus {
        case file
        case directory
        case none
    }
    
    func getDataFromFile(fullPath:String) -> Data? {
        // Create a FileHandle instance
        let file: FileHandle? = FileHandle(forReadingAtPath: fullPath)
        
        if file != nil {
            // Read all the data
            let data = file?.readDataToEndOfFile()
            // Close the file
            file?.closeFile()
            return data
        }
        else {
            print("Ooops! Something went wrong!")
            return nil
        }
    }
    
    func getJSONFromFile(fullPath:String) -> JSON? {
        let data = self.getDataFromFile(fullPath: fullPath)
        if let data = data {
            return JSON(data: data)
        } else {
            return nil
        }
    }
    
    func writeFile(fullPath:String, fileName:String, data:String) {
        let path = "\(fullPath)/\(fileName)"
        if (self.directoryExists(fullPath: fullPath)) {
            do {
                try data.write(to: URL(fileURLWithPath: path), atomically: true, encoding: String.Encoding.utf8)
            } catch {
                print("Could not write to file \(path)")
            }
        } else {
            print("Directory does not exist")
        }
    }
    
    func createDirectory(fullPath:String) {
        if (!self.directoryExists(fullPath: fullPath)) {
            do {
                try FileManager.default.createDirectory(at: URL(fileURLWithPath: fullPath), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Could not create directory at \(fullPath)")
            }
        }
    }
    
    func fileExists(fullPath:String) -> Bool {
        return self.exists(fullPath: fullPath) == .file
    }
    
    func directoryExists(fullPath:String) -> Bool {
        return self.exists(fullPath: fullPath) == .directory
    }
    
    func exists(fullPath:String) -> Filestatus {
        let fileManager = FileManager.default
        var isDir : ObjCBool = false
        if fileManager.fileExists(atPath: fullPath, isDirectory:&isDir) {
            if isDir.boolValue {
                // file exists and is a directory
                return .directory
            } else {
                // file exists and is not a directory
                return .file
            }
        } else {
            // file does not exist
            return .none
        }
    }
}
