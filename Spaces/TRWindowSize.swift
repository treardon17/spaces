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
    
    var statusBarHeight:CGFloat{
        get {
            var statusBarHeight:CGFloat = 0
            if let menu = NSApplication.shared.mainMenu {
                statusBarHeight = menu.menuBarHeight
            }
            return statusBarHeight
        }
    }
    
    // Relative to window size
    var originX:CGFloat = 0
    var originY:CGFloat = 0
    // Proportions
    var widthProp:CGFloat? = 1
    var heightProp:CGFloat? = 1
    var xProp:CGFloat = 0
    var yProp:CGFloat = 0
    // Set values
    var width:CGFloat?
    var height:CGFloat?
    var insetTop:CGFloat = 0
    var insetBottom:CGFloat = 0
    var insetLeft:CGFloat = 0
    var insetRight:CGFloat = 0
    
    var offsetX:CGFloat = 0
    var offsetY:CGFloat = 0
    
    init(xProp:CGFloat, yProp:CGFloat, widthProp: CGFloat?, heightProp: CGFloat?){
        super.init()
        self.widthProp = widthProp
        self.heightProp = heightProp
        self.xProp = xProp
        self.yProp = yProp
    }
    
    init(xProp:CGFloat, yProp:CGFloat, originX:CGFloat, originY:CGFloat, widthProp:CGFloat?, heightProp:CGFloat?) {
        super.init()
        self.xProp = xProp
        self.yProp = yProp
        self.originX = originX
        self.originY = originY
        self.widthProp = widthProp
        self.heightProp = heightProp
    }
    
    convenience init(xProp:CGFloat, yProp:CGFloat, originX:CGFloat, originY:CGFloat, widthProp:CGFloat?, heightProp:CGFloat?, inset:CGFloat) {
        self.init(xProp: xProp, yProp: yProp, originX: originX, originY: originY, widthProp: widthProp, heightProp: heightProp)
        self.insetTop = inset
        self.insetBottom = inset
        self.insetLeft = inset
        self.insetRight = inset
    }
    
    convenience init(xProp:CGFloat, yProp:CGFloat, originX:CGFloat, originY:CGFloat, widthProp:CGFloat?, heightProp:CGFloat?, insetTop:CGFloat, insetBottom:CGFloat, insetLeft:CGFloat, insetRight:CGFloat, offsetX:CGFloat, offsetY:CGFloat) {
        self.init(xProp: xProp, yProp: yProp, originX: originX, originY: originY, widthProp: widthProp, heightProp: heightProp)
        self.insetTop = insetTop
        self.insetBottom = insetBottom
        self.insetLeft = insetLeft
        self.insetRight = insetRight
        self.offsetX = offsetX
        self.offsetY = offsetY
    }
    
    convenience init(xProp:CGFloat, yProp:CGFloat, widthProp:CGFloat?, heightProp:CGFloat?, insetTop:CGFloat, insetBottom:CGFloat, insetLeft:CGFloat, insetRight:CGFloat) {
        self.init(xProp: xProp, yProp: yProp, widthProp: widthProp, heightProp: heightProp)
        self.insetTop = insetTop
        self.insetBottom = insetBottom
        self.insetLeft = insetLeft
        self.insetRight = insetRight
    }
    
    convenience init(xProp:CGFloat, yProp:CGFloat, widthProp:CGFloat, heightProp:CGFloat, inset:CGFloat) {
        self.init(xProp: xProp, yProp: yProp, widthProp: widthProp, heightProp: heightProp, insetTop: inset, insetBottom: inset, insetLeft: inset, insetRight: inset)
    }
    
    init(xProp:CGFloat, yProp:CGFloat, originX:CGFloat, originY:CGFloat, width:CGFloat, height:CGFloat, insetTop:CGFloat, insetBottom:CGFloat, insetLeft:CGFloat, insetRight:CGFloat, offsetX:CGFloat, offsetY:CGFloat) {
        super.init()
        self.xProp = xProp
        self.yProp = yProp
        self.originX = originX
        self.originY = originY
        self.insetTop = insetTop
        self.insetBottom = insetBottom
        self.insetLeft = insetLeft
        self.insetRight = insetRight
    }
    
    init(xProp:CGFloat, yProp:CGFloat, widthProp:CGFloat?, heightProp:CGFloat?, width:CGFloat?, height:CGFloat?, originX:CGFloat, originY:CGFloat, insetTop:CGFloat, insetBottom:CGFloat, insetLeft:CGFloat, insetRight:CGFloat, offsetX:CGFloat, offsetY:CGFloat) {
        super.init()
        self.xProp = xProp
        self.yProp = yProp
        self.widthProp = widthProp
        self.heightProp = heightProp
        self.originX = originX
        self.originY = originY
        self.insetTop = insetTop
        self.insetBottom = insetBottom
        self.insetLeft = insetLeft
        self.insetRight = insetRight
        
        if let width = width{ self.width = width }
        if let height = height{ self.height = height }
    }
    
    func getSizedRectForScreen(screen:NSScreen, window: SIWindow) -> CGRect {
        // Get the dimensions of the screen
        let frame = screen.frameWithoutDockOrMenu()
        // Convert that frame from having an origin in the
        // bottom left to one with an origin of top left
        let rect = screen.backingAlignedRect(frame, options: AlignmentOptions.alignAllEdgesInward)
        let windowFrame = window.frame()
        
        var windowHeight:CGFloat = windowFrame.size.height
        var windowWidth:CGFloat = windowFrame.size.width
        
        if let width = self.width, let height = self.height{
            windowWidth = width
            windowHeight = height
        } else if let widthProp = self.widthProp, let heightProp = self.heightProp {
            windowHeight = (rect.size.height * heightProp) - (self.insetTop + self.insetBottom)
            windowWidth = (rect.size.width * widthProp) - (self.insetRight + self.insetLeft)
        }
        
        let totalHeight = windowHeight + self.insetTop + self.insetBottom
        let totalWidth = windowWidth + self.insetLeft + self.insetRight
        
        let y:CGFloat = ((rect.origin.y + (rect.size.height * self.yProp)) + self.insetTop + self.offsetY) - (totalHeight * self.originY)
        let x:CGFloat = ((rect.origin.x + (rect.size.width * self.xProp)) + self.insetLeft + self.offsetX) - (totalWidth * self.originX)
        
        return CGRect(x: x, y: y, width: windowWidth, height: windowHeight)
    }
    
    func getRectForUnmutableWindow(screen:NSScreen, window: SIWindow) -> CGRect {
        let windowFrame = window.frame()
        let screenX = screen.frame.origin.x
        let screenY = screen.frame.origin.y
        let screenXExtent = screenX + screen.frame.width
        let screenYExtent = screenY + screen.frame.height
        
        let windowX = windowFrame.origin.x
        let windowY = windowFrame.origin.y
        let windowXExtent = windowX + windowFrame.width
        let windowYExtent = windowY + windowFrame.height
        
        var newX:CGFloat = windowX
        var newY:CGFloat = windowY
        
        // If part of the window is off the screen
        if (windowX < screenX) {
            let difference = screenX - windowX
            newX += (difference + self.offsetX - self.insetLeft)
        } else if (windowXExtent > screenXExtent) {
            let difference = windowXExtent - screenXExtent
            newX -= (difference + self.offsetX + self.insetRight)
        }
        
        if (windowY < screenY) {
//            let difference = screenY - windowY
//            newY += (difference + self.offsetY - self.insetTop)
        } else if (windowYExtent > screenYExtent) {
//            let difference = windowYExtent - screenYExtent
//            newY -= (difference + self.offsetY + self.insetBottom)
        }
        
        return CGRect(x: newX, y: newY, width: windowFrame.width, height: windowFrame.height)
    }
    
//    func getSizedRectForFrame(frame:CGRect) -> CGRect{
//        let x = (frame.origin.x + (frame.width * self.xProp))
//        let y = (frame.origin.y + self.statusBarHeight + (frame.height * self.yProp))
//        return CGRect(x: x , y: y, width: frame.width * self.widthProp, height: (frame.height * self.heightProp) - self.statusBarHeight)
//    }
}
