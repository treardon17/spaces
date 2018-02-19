//
//  Logging.swift
//  Spaces
//
//  Created by Tyler Reardon on 7/31/17.
//  Copyright © 2017 Tyler Reardon. All rights reserved.
//

import Foundation

class Logger: NSObject{
    static func log(_ object: Any?...){
        print("--- ", object , " ---")
    }
    
    static func error(_ object: Any?){
        Logger.log("ERROR: ", object ?? "_nil_")
    }
}
