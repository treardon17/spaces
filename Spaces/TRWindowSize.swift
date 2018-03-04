//
//  TRWindowSize.swift
//  Spaces
//
//  Created by Tyler Reardon on 8/2/17.
//  Copyright © 2017 Tyler Reardon. All rights reserved.
//

import Foundation
import AppKit
import Silica

class TRWindowSize:NSObject{
    
    enum Edge {
        case top
        case bottom
        case left
        case right
    }
    
//    enum Position {
//        case center
//        case normal
//    }
    
    var statusBarHeight:CGFloat{
        get {
            var statusBarHeight:CGFloat = 0
            if let menu = NSApplication.shared.mainMenu {
                statusBarHeight = menu.menuBarHeight
            }
            return statusBarHeight
        }
    }
    
//    var positionX:Position = .normal
//    var positionY:Position = .normal
    var transformX:CGFloat = 0
    var transformY:CGFloat = 0
    var widthProp:CGFloat = 1
    var heightProp:CGFloat = 1
    var xProp:CGFloat = 0
    var yProp:CGFloat = 0
    var insetTop:CGFloat = 0
    var insetBottom:CGFloat = 0
    var insetLeft:CGFloat = 0
    var insetRight:CGFloat = 0
    
    var offsetX:CGFloat = 0
    var offsetY:CGFloat = 0
    
    init(xProp:CGFloat, yProp:CGFloat, widthProp: CGFloat, heightProp: CGFloat){
        super.init()
        self.widthProp = widthProp
        self.heightProp = heightProp
        self.xProp = xProp
        self.yProp = yProp
    }
    
    init(xProp:CGFloat, yProp:CGFloat, transformX:CGFloat, transformY:CGFloat, widthProp:CGFloat, heightProp:CGFloat) {
        super.init()
        self.xProp = xProp
        self.yProp = yProp
        self.transformX = transformX
        self.transformY = transformY
        self.widthProp = widthProp
        self.heightProp = heightProp
    }
    
    convenience init(xProp:CGFloat, yProp:CGFloat, transformX:CGFloat, transformY:CGFloat, widthProp:CGFloat, heightProp:CGFloat, inset:CGFloat) {
        self.init(xProp: xProp, yProp: yProp, transformX: transformX, transformY: transformY, widthProp: widthProp, heightProp: heightProp)
        self.insetTop = inset
        self.insetBottom = inset
        self.insetLeft = inset
        self.insetRight = inset
    }
    
    convenience init(xProp:CGFloat, yProp:CGFloat, transformX:CGFloat, transformY:CGFloat, widthProp:CGFloat, heightProp:CGFloat, insetTop:CGFloat, insetBottom:CGFloat, insetLeft:CGFloat, insetRight:CGFloat, offsetX:CGFloat, offsetY:CGFloat) {
        self.init(xProp: xProp, yProp: yProp, transformX: transformX, transformY: transformY, widthProp: widthProp, heightProp: heightProp)
        self.insetTop = insetTop
        self.insetBottom = insetBottom
        self.insetLeft = insetLeft
        self.insetRight = insetRight
        self.offsetX = offsetX
        self.offsetY = offsetY
    }
    
    convenience init(xProp:CGFloat, yProp:CGFloat, widthProp:CGFloat, heightProp:CGFloat, insetTop:CGFloat, insetBottom:CGFloat, insetLeft:CGFloat, insetRight:CGFloat) {
        self.init(xProp: xProp, yProp: yProp, widthProp: widthProp, heightProp: heightProp)
        self.insetTop = insetTop
        self.insetBottom = insetBottom
        self.insetLeft = insetLeft
        self.insetRight = insetRight
    }
    
    convenience init(xProp:CGFloat, yProp:CGFloat, widthProp:CGFloat, heightProp:CGFloat, inset:CGFloat) {
        self.init(xProp: xProp, yProp: yProp, widthProp: widthProp, heightProp: heightProp, insetTop: inset, insetBottom: inset, insetLeft: inset, insetRight: inset)
    }
    
    func getSizedRectForScreen(screen:NSScreen, window: SIWindow) -> CGRect {
        // Get the dimensions of the screen
        let frame = screen.frameIncludingDockAndMenu()
        // Convert that frame from having an origin in the
        // bottom left to one with an origin of top left
        let rect = screen.backingAlignedRect(frame, options: AlignmentOptions.alignAllEdgesInward)
        
        let windowHeight = (rect.size.height * self.heightProp) - (self.insetTop + self.insetBottom)
        let windowWidth = (rect.size.width * self.widthProp) - (self.insetRight + self.insetLeft)
        
        let y:CGFloat = ((rect.origin.y + (rect.size.height * self.yProp)) + self.insetTop + self.offsetY) - (windowHeight * self.transformY)
        let x:CGFloat = ((rect.origin.x + (rect.size.width * self.xProp)) + self.insetLeft + self.offsetX) - (windowWidth * self.transformX)
        
        return CGRect(x: x, y: y, width: windowWidth, height: windowHeight)
    }
    
    func getSizedRectForFrame(frame:CGRect) -> CGRect{
        let x = (frame.origin.x + (frame.width * self.xProp))
        let y = (frame.origin.y + self.statusBarHeight + (frame.height * self.yProp))
        return CGRect(x: x , y: y, width: frame.width * self.widthProp, height: (frame.height * self.heightProp) - self.statusBarHeight)
    }
}
