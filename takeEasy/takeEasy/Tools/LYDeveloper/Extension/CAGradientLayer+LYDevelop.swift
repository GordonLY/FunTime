//
//  CAGradientLayer+LYDevelop.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/5.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    
    enum LYGradientLayerDirectionOption {
        case top2down
        case left2right
        case topLeft2downRight
        case topRight2downLeft
        case other
    }
    
    class func ly_gradientLayerWith(colors: [CGColor], frame: CGRect, direction: LYGradientLayerDirectionOption) -> CAGradientLayer {
        
        let layer = CAGradientLayer()
        layer.frame = frame
        layer.colors = colors
        var start = CGPoint(x: 0.5, y: 0)
        var end = CGPoint(x: 0.5, y: 1)
        switch direction {
        case .top2down:
            start = CGPoint(x: 0.5, y: 0)
            end = CGPoint(x: 0.5, y: 1)
        case .left2right:
            start = CGPoint(x: 0, y: 0.5)
            end = CGPoint(x: 1, y: 0.5)
        case .topLeft2downRight:
            start = CGPoint(x: 0, y: 0)
            end = CGPoint(x: 1, y: 1)
        case .topRight2downLeft:
            start = CGPoint(x: 1, y: 0)
            end = CGPoint(x: 0, y: 1)
        case .other:
            break
        }
        layer.startPoint = start
        layer.endPoint = end
        return layer
        
    }
}
