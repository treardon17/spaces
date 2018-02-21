//
//  TRWindowSize.swift
//  Spaces
//
//  Created by Tyler Reardon on 8/2/17.
//  Copyright © 2017 Tyler Reardon. All rights reserved.
//

import Foundation

class TRWindowSize:NSObject{
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
    
    func getSizedRectForFrame(frame:CGRect) -> CGRect{
        let x = (frame.origin.x + (frame.width * self.xProportion))
        let y = (frame.origin.y + (frame.height * self.yProportion))
        return CGRect(x: x , y: y, width: frame.width * self.widthProportion, height: frame.height * self.heightProportion)
    }
}
