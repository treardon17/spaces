//
//  CGRect.swift
//  Spaces
//
//  Created by Tyler Reardon on 7/30/17.
//  Copyright © 2017 Tyler Reardon. All rights reserved.
//

import Foundation

extension CGRect{
    func toNSRect() -> NSRect{
        return NSRectFromCGRect(self)
    }
}
