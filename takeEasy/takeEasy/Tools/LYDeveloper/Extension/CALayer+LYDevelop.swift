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
    
    /// layer旋转360°
    ///
    /// - Parameter duration: 时间(旋转360度需要的时间)
    /// - Parameter repeatCount: 重复次数
    func start360Rotate(duration: TimeInterval, repeatCount: Float) {
        if let _ = base.animation(forKey: "ly_rotate360Degree") {
            let pausedTime = base.timeOffset
            base.speed = 1.0
            base.timeOffset = 0.0
            base.beginTime = 0.0
            let timeSincePause = base.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
            base.beginTime = timeSincePause
            return
        }
        let rotation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = duration
        rotation.repeatCount = repeatCount
        rotation.isCumulative = true
        rotation.isRemovedOnCompletion = false
        rotation.fillMode = kCAFillModeForwards
        base.speed = 1.0
        base.add(rotation, forKey: "ly_rotate360Degree")
    }
    func pause360Rotate() {
        guard let _ = base.animation(forKey: "ly_rotate360Degree") else { return }
        let pauseTime = base.convertTime(CACurrentMediaTime(), from: nil)
        base.speed = 0
        base.timeOffset = pauseTime
    }
    func stopRotate360() {
        base.removeAnimation(forKey: "ly_rotate360Degree")
    }
    
}

