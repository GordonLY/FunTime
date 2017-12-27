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
    func ly_image(tintColor:UIColor) -> UIImage {
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
    class func ly_image(color:UIColor, size: CGSize, cornerRadius: CGFloat) -> UIImage {
     
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
//    static func ==(lhs: UIImage, rhs: UIImage) -> Bool  {
//        return isEqual(lhs: self, rhs: rhs)
//    }
    
    
    static func isEqual (lhs: UIImage, rhs: UIImage) -> Bool {
        guard let data1 = UIImagePNGRepresentation(lhs),
            let data2 = UIImagePNGRepresentation(rhs) else {
                return false
        }
        return data1 == data2
    }
}

extension LYDevelop where Base: UIImage {
    
    /// 缩小图片大小
    func scale(to newSize: CGSize) -> UIImage {
        guard base.size != newSize else { return base }
        let scaledRect = fixPictureSize(newSize: newSize)
        UIGraphicsBeginImageContextWithOptions(scaledRect.size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        base.draw(in: scaledRect)
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
    private func fixPictureSize(newSize: CGSize) -> CGRect {
        let ratio = max(newSize.width / base.size.width,
                        newSize.height / base.size.height)
        let width = base.size.width * ratio
        let height = base.size.height * ratio
        let scaledRect = CGRect(x: 0, y: 0,
                                width: width, height: height)
        return scaledRect
    }
    
    /// 给图片切圆角
    func drawRectWithRoundedCorner(radius: CGFloat, _ sizetoFit: CGSize) -> UIImage {
        guard radius > 0 else { return base }
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: sizetoFit)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        let path = UIBezierPath.init(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: CGSize.init(width: radius, height: radius)).cgPath
        context.addPath(path)
        context.clip()
        base.draw(in: rect)
        context.drawPath(using: .fillStroke)
        defer { UIGraphicsEndImageContext() }
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
}

