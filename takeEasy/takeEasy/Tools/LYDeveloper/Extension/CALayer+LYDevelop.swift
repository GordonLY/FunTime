//
//  CALayer+LYDevelop.swift
//  kemiBear
//
//  Created by 李扬 on 2017/4/18.
//  Copyright © 2017年 李扬. All rights reserved.
//

import UIKit

extension LYDevelop where Base: CALayer {
    
    /// 给layer添加阴影
    ///
    /// - Parameter color:  颜色
    /// - Parameter blur:   blur radius
    /// - Parameter opacity: 不透明
    /// - Parameter rect:   shadowPath
    ///
    func addShadowWith(color: UIColor, blur: CGFloat, opacity: CGFloat, path: CGRect) {
        base.shadowColor = color.cgColor
        base.shadowRadius = blur
        base.shadowOpacity = Float(opacity)
        base.shadowPath = UIBezierPath.init(rect: path).cgPath
    }
    
    /// 设置圆角
    func setRoundRect() {
        base.cornerRadius = base.bounds.size.height * 0.5
        base.masksToBounds = true
    }
    /// 设置圆角 角度
    func setCornerRadius(_ radius:CGFloat) {
        base.cornerRadius = radius
        base.masksToBounds = true
    }
    
    /// 设置border
    func setBorder(width: CGFloat, color: UIColor) {
        base.borderColor = color.cgColor
        base.borderWidth = width
        base.masksToBounds = true
    }
}

