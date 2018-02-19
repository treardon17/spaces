//
//  NSRect.swift
//  Spaces
//
//  Created by Tyler Reardon on 7/30/17.
//  Copyright © 2017 Tyler Reardon. All rights reserved.
//

import Foundation

extension NSRect{
    func toCGRect(parentHeight: CGFloat) -> CGRect{
        return NSRectToCGRect(self)
    }
}
