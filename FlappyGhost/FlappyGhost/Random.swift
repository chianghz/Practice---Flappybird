//
//  Random.swift
//  FlappyGhost
//
//  Created by Kevin on 2015/12/22.
//  Copyright © 2015年 Kevin. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat{
    
    public static func random() -> CGFloat {
        
        return CGFloat(Float(arc4random()) / 0xffffffff)
    }
    
    public static func random (min min:CGFloat, max:CGFloat) -> CGFloat{
        
        return CGFloat.random() * (max-min) + min
    }
    
}