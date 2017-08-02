//
//  UIImage+LYDeveloper.swift
//  kemiBear
//
//  Created by 李扬 on 2017/4/18.
//  Copyright © 2017年 李扬. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 改变图标的颜色，用于小图标绘制
    /// ## 只用于纯色图标 ##
    /// - Parameter tintColor: 目标颜色
    ///
    /// - Returns: 改变颜色后的image
    func lyImage(tintColor:UIColor) -> UIImage {
        //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        tintColor.setFill()
        let bounds = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIRectFill(bounds)
        //Draw the tinted image in context
        self.draw(in: bounds, blendMode: .destinationIn, alpha: 1)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
    
    /// 返回一张带有颜色尺寸带圆角的 image
    class func lyImage(color:UIColor, size: CGSize, cornerRadius: CGFloat) -> UIImage {
     
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        let path = UIBezierPath.init(roundedRect: rect, cornerRadius: cornerRadius)
        path.lineWidth = 0
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        path.fill()
        path.stroke()
        path.addClip()
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
