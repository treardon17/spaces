//
//  TRWindowSize.swift
//  Spaces
//
//  Created by Tyler Reardon on 8/2/17.
//  Copyright © 2017 Tyler Reardon. All rights reserved.
//

import Foundation
import AppKit

class TRWindowSize:NSObject{
    var statusBarHeight:CGFloat{
        get {
            var statusBarHeight:CGFloat = 0
            if let menu = NSApplication.shared.mainMenu {
                statusBarHeight = menu.menuBarHeight
            }
            return statusBarHeight
        }
    }
    
    private var _widthProp:CGFloat!
    var widthProportion:CGFloat{
        get{
            return self._widthProp
        }
    }
    private var _heightProp:CGFloat!
    var heightProportion:CGFloat{
        get{
            return self._heightProp
        }
    }
    private var _xProp:CGFloat!
    var xProportion:CGFloat{
        get{
            return self._xProp
        }
    }
    private var _yProp:CGFloat!
    var yProportion:CGFloat{
        get{
            return self._yProp
        }
    }
    private var _xOffset:CGFloat?
    var xOffset:CGFloat?{
        get{
            return self._xOffset
        }
    }
    private var _yOffset:CGFloat?
    var yOffset:CGFloat?{
        get{
            return self._yOffset
        }
    }
    private var _widthOffset:CGFloat?
    var widthOffset:CGFloat?{
        get{
            return self._widthOffset
        }
    }
    private var _heightOffset:CGFloat?
    var heightOffset:CGFloat?{
        get{
            return self._heightOffset
        }
    }
    
    init(xProp:CGFloat, yProp:CGFloat, widthProp: CGFloat, heightProp: CGFloat){
        super.init()
        self._widthProp = widthProp
        self._heightProp = heightProp
        self._xProp = xProp
        self._yProp = yProp
    }
    
    convenience init(xProp:CGFloat, yProp:CGFloat, xOffset:CGFloat, yOffset:CGFloat, widthProp:CGFloat, heightProp:CGFloat, widthOffset:CGFloat, heightOffset:CGFloat) {
        self.init(xProp: xProp, yProp: yProp, widthProp: widthProp, heightProp: heightProp)
        self._xOffset = xOffset
        self._yOffset = yOffset
        self._widthOffset = widthOffset
        self._heightOffset = heightOffset
    }
    
    func getInvertedSizedRectForFrame(frame:CGRect) -> CGRect {
        let windowHeight = (frame.size.height * self.heightProportion) - (self.statusBarHeight * self.heightProportion)
        let windowWidth = (frame.size.width * self.widthProportion)
////        let newOriginY = -frame.origin.y - frame.height + windowHeight
////        let y = -(frame.size.height - frame.origin.y) + (frame.size.height * self.yProportion)
//        let y:CGFloat = -558 + self.statusBarHeight
        let x = (frame.origin.x + (frame.size.width * self.xProportion))
//        let y = (frame.origin.y + (frame.size.height * self.yProportion))
//        let y = (frame.origin.y - frame.size.height) + (frame.size.height * self.yProportion) + windowHeight
//        let y = (-frame.origin.y + (frame.size.height * self.yProportion)) - (frame.size.height * self.heightProportion ) + (self.statusBarHeight * self.heightProportion)
        let y = (-frame.origin.y + (frame.size.height * self.yProportion)) + (self.statusBarHeight * self.heightProportion)
        print("y is: ", y)
        print("height is: ", windowHeight)
        print("status bar height: ", self.statusBarHeight)
//        print("frame height:", frame.size.height)
//        print("y proportion: ", self.yProportion)
//        print("status bar height:", self.statusBarHeight)
//        print("window height:", windowHeight)
//
//        return CGRect(x: x , y: y, width: windowWidth, height: windowHeight)
        
//        TRY 2
//        var newFrame = frame
//        newFrame.origin.y -= frame.size.height
//        newFrame.origin.y += windowHeight
//        newFrame.origin.y += y
//        newFrame.origin.x = x
//        newFrame.size.width = windowWidth
//        newFrame.size.height = windowHeight
//        return newFrame
        
        
//        return NSMakeRect(x, y, windowWidth, windowHeight)
        return CGRect(x: x, y: y, width: windowWidth, height: windowHeight)
    }
    
    func getSizedRectForFrame(frame:CGRect) -> CGRect{
        let x = (frame.origin.x + (frame.width * self.xProportion))
        let y = (frame.origin.y + self.statusBarHeight + (frame.height * self.yProportion))
        return CGRect(x: x , y: y, width: frame.width * self.widthProportion, height: (frame.height * self.heightProportion) - self.statusBarHeight)
    }
}
