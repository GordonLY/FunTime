//
//  CALayer+LYDevelop.swift
//  kemiBear
//
//  Created by 李扬 on 2017/4/18.
//  Copyright © 2017年 李扬. All rights reserved.
//

import UIKit

extension CALayer {

    
    /// 设置圆角
    func lySetRoundRect() {
        self.cornerRadius = self.bounds.size.height * 0.5
        self.masksToBounds = true
    }
    /// 设置圆角 角度
    func lySetCornerRadius(_ radius:CGFloat) {
        self.cornerRadius = radius
        self.masksToBounds = true
    }
    
    /// 设置border
    func lySetBorder(width: CGFloat, color: UIColor) {
        self.borderColor = color.cgColor
        self.borderWidth = width
        self.masksToBounds = true   
    }
}
