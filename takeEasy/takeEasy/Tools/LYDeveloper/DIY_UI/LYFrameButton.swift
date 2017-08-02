//
//  LYFrameButton.swift
//  kemiBear
//
//  Created by 李扬 on 2017/4/18.
//  Copyright © 2017年 李扬. All rights reserved.
//

import UIKit


extension UIButton {
    
    func lyExchangeLabelAndImagePosition(interval:CGFloat) {
        
        let imageW = (self.imageView?.bounds.width ?? 0.0) + interval * 0.5
        let lableW = (self.titleLabel?.bounds.width ?? 0.0) + interval * 0.5
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageW, 0, imageW)
        self.imageEdgeInsets = UIEdgeInsetsMake(0, lableW, 0, -lableW)
    }
}


class LYFrameButton: UIButton {

    ///  记录一些其他的值
    var assistValue = ""
    ///  文字颜色(只用于辅助记录, 不会做任何其他设置)
    var txtColor = UIColor.white
    
    ///  设定label的frame
    var lyTitleLabelFrame = CGRect.zero {
        didSet {
            self.setNeedsLayout()
        }
    }
    ///  设定image的frame
    var lyImageViewFrame = CGRect.zero {
        didSet {
            self.setNeedsLayout()
        }
    }
    ///  点击动画 缩放
    var isAnimationClick = false
    
    ///  点击时 整个btn的alpha变为0.5
    var isAlphaHalfWhenHlight = false
    
    private var borderColor: CGColor!
    private var borderColorHalf: CGColor!
    ///  border Highlight时 颜色变化
    var isBorderAnimate = false {
        didSet {
            borderColor = self.layer.borderColor ?? UIColor.clear.cgColor
            borderColorHalf = borderColor.copy(alpha: 0.5)
        }
    }
    
    // MARK: - ********* Override Method
    override func layoutSubviews() {
        super.layoutSubviews()
        if !lyImageViewFrame.isEmpty {
            imageView?.frame = lyImageViewFrame
        }
        if !lyTitleLabelFrame.isEmpty {
            titleLabel?.frame = lyTitleLabelFrame
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if (isAnimationClick) {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.77, initialSpringVelocity: 0, options: .curveLinear, animations: { 
                    if self.isHighlighted {
                        self.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
                    } else {
                        self.transform = CGAffineTransform.identity
                    }
                }, completion: nil)
            }
            if (isBorderAnimate) {
                if (isHighlighted) {
                    self.layer.borderColor = self.borderColorHalf
                } else {
                    self.layer.borderColor = self.borderColor
                }
            }
            if isAlphaHalfWhenHlight {
                if (isHighlighted) {
                    self.alpha = 0.6
                } else {
                    self.alpha = 1
                }
            }
        }
    }
}
