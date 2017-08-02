//
//  UIImageView+ScrollIndicator.swift
//  泰行销
//
//  Created by Gordon on 2017/7/27.
//  Copyright © 2017年 taikanglife. All rights reserved.
//

import UIKit

extension UIImageView {
    
    /// 重写 使scrollView的indicatorView一直显示
    open override var alpha: CGFloat {
        get {
            return super.alpha
        }
        set {
            if self.superview?.tag == ly_alwaysShowScrollIndicator {
                super.alpha = 1
            } else {
                super.alpha = newValue
            }
        }
    }
}
