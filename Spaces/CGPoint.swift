//
//  CGPoint.swift
//  Spaces
//
//  Created by Tyler Reardon on 8/1/17.
//  Copyright © 2017 Tyler Reardon. All rights reserved.
//

import Foundation

extension CGPoint{
    mutating func setOriginFromFrame(frame: CGRect){
        self.y = frame.height - self.y
    }
}
