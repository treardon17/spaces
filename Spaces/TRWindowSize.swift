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
    
    enum Edge {
        case top
        case bottom
        case left
        case right
    }
    
    enum Position {
        case center
        case any
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
    
    private var _position:Position = .any
    var position:Position{
        get{
            return self._position
        }
    }
    private var _widthProp:CGFloat = 1
    var widthProportion:CGFloat{
        get{
            return self._widthProp
        }
    }
    private var _heightProp:CGFloat = 1
    var heightProportion:CGFloat{
        get{
            return self._heightProp
        }
    }
    private var _xProp:CGFloat = 0
    var xProportion:CGFloat{
        get{
            return self._xProp
        }
    }
    private var _yProp:CGFloat = 0
    var yProportion:CGFloat{
        get{
            return self._yProp
        }
    }
    private var _insetTop:CGFloat = 0
    var insetTop:CGFloat{
        get{
            return self._insetTop
        }
    }
    private var _insetBottom:CGFloat = 0
    var insetBottom:CGFloat{
        get{
            return self._insetBottom
        }
    }
    private var _insetLeft:CGFloat = 0
    var insetLeft:CGFloat{
        get{
            return self._insetLeft
        }
    }
    private var _insetRight:CGFloat = 0
    var insetRight:CGFloat{
        get{
            return self._insetRight
        }
    }
    
    init(xProp:CGFloat, yProp:CGFloat, widthProp: CGFloat, heightProp: CGFloat){
        super.init()
        self._widthProp = widthProp
        self._heightProp = heightProp
        self._xProp = xProp
        self._yProp = yProp
    }
    
    init(position:Position, widthProp:CGFloat, heightProp:CGFloat) {
        super.init()
        self._position = position
        self._widthProp = widthProp
        self._heightProp = heightProp
    }
    
    convenience init(position:Position, widthProp:CGFloat, heightProp:CGFloat, inset:CGFloat) {
        self.init(position: position, widthProp: widthProp, heightProp: heightProp)
        self._insetTop = inset
        self._insetBottom = inset
        self._insetLeft = inset
        self._insetRight = inset
    }
    
    convenience init(xProp:CGFloat, yProp:CGFloat, widthProp:CGFloat, heightProp:CGFloat, insetTop:CGFloat, insetBottom:CGFloat, insetLeft:CGFloat, insetRight:CGFloat) {
        self.init(xProp: xProp, yProp: yProp, widthProp: widthProp, heightProp: heightProp)
        self._insetTop = insetTop
        self._insetBottom = insetBottom
        self._insetLeft = insetLeft
        self._insetRight = insetRight
    }
    
    convenience init(xProp:CGFloat, yProp:CGFloat, widthProp:CGFloat, heightProp:CGFloat, inset:CGFloat) {
        self.init(xProp: xProp, yProp: yProp, widthProp: widthProp, heightProp: heightProp, insetTop: inset, insetBottom: inset, insetLeft: inset, insetRight: inset)
    }
    
    func getSizedRectForScreen(screen:NSScreen) -> CGRect {
        // Get the dimensions of the screen
        let frame = screen.frameIncludingDockAndMenu()
        // Convert that frame from having an origin in the
        // bottom left to one with an origin of top left
        let rect = screen.backingAlignedRect(frame, options: AlignmentOptions.alignAllEdgesInward)
        
        let windowHeight = (rect.size.height * self.heightProportion) - (self.insetTop + self.insetBottom)
        let windowWidth = (rect.size.width * self.widthProportion) - (self.insetRight + self.insetLeft)
        
        var x:CGFloat = 0
        var y:CGFloat = 0
        
        if (self.position == .any) {
            x = (rect.origin.x + (rect.size.width * self.xProportion)) + self.insetLeft
            y = (rect.origin.y + (rect.size.height * self.yProportion)) + self.insetTop
        } else if (self.position == .center) {
            x = (rect.origin.x + (rect.size.width / 2)) - (windowWidth / 2)
            y = (rect.origin.y + (rect.size.height / 2)) - (windowHeight / 2)
        }
        
        return CGRect(x: x, y: y, width: windowWidth, height: windowHeight)
    }
    
    func getSizedRectForFrame(frame:CGRect) -> CGRect{
        let x = (frame.origin.x + (frame.width * self.xProportion))
        let y = (frame.origin.y + self.statusBarHeight + (frame.height * self.yProportion))
        return CGRect(x: x , y: y, width: frame.width * self.widthProportion, height: (frame.height * self.heightProportion) - self.statusBarHeight)
    }
}
