//
//  TRWindowSize.swift
//  Spaces
//
//  Created by Tyler Reardon on 8/2/17.
//  Copyright © 2017 Tyler Reardon. All rights reserved.
//

import Foundation

class TRWindowSize:NSObject{
    private var _widthProportion:CGFloat!
    var widthProportion:CGFloat{
        get{
            return self._widthProportion
        }
    }
    private var _heightProportion:CGFloat!
    var heightProportion:CGFloat{
        get{
            return self._heightProportion
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
    
    init(xProp:CGFloat, yProp:CGFloat, widthProp: CGFloat, heightProp: CGFloat){
        super.init()
        self._widthProportion = widthProp
        self._heightProportion = heightProp
        self._xProp = xProp
        self._yProp = yProp
    }
    
    func getSizedRectForFrame(frame:CGRect) -> CGRect{
        let x = (frame.origin.x + (frame.width * self.xProportion))
        let y = (frame.origin.y + (frame.height * self.yProportion))
        return CGRect(x: x , y: y, width: frame.width * self.widthProportion, height: frame.height * self.heightProportion)
    }
}
