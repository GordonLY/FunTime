//
//  LYCircleProgressView.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/7.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit



class LYCircleProgressView: UIView {

    var label: UICountingLabel!
    var progress: CGFloat = 0 {
        didSet {
            guard progress >= 0,
                progress <= 1 else {
                    return
            }
            self.p_updateProgress(from: oldValue, to: progress)
        }
    }
    private let animKeyPath = "LYCircleProgress_strokeEnd"
    func p_updateProgress(from: CGFloat, to: CGFloat) {
        
        circleLayer.removeAnimation(forKey: animKeyPath)
        let animation = CABasicAnimation.init(keyPath: "strokeEnd")
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.duration = 0.3
        animation.fromValue = from
        animation.toValue = to
        circleLayer.add(animation, forKey: animKeyPath)
        label.count(from: from, to: to, withDuration: 0.3)
    }
    
    
    private let lineWid = kFitCeilWid(10)
    private let selColor = kThemeColor()
    private let bgColor = kSubTitleColor()
    private var circleLayer = CAShapeLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGray
        
        label = UICountingLabel.init(frame: self.bounds)
        label.textColor = kTitleColor()
        label.font = kRegularFitFont(size: 11)
        label.textAlignment = .center
        label.text = "0%"
        label.formatBlock = { (value) in
            return String.init(format: "%.0f%%", value * 100)
        }
        self.addSubview(label)
      
        let path = UIBezierPath.init(arcCenter: self.b_center, radius: self.width * 0.5 - lineWid, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        let bgLayer = CAShapeLayer.init()
        bgLayer.lineWidth = lineWid
        bgLayer.frame = self.bounds
        bgLayer.strokeColor = bgColor.cgColor
        bgLayer.fillColor = UIColor.clear.cgColor
        bgLayer.path = path.cgPath
        self.layer.addSublayer(bgLayer)

        let startAngle = CGFloat.pi * -0.5
        let endAngle = startAngle + CGFloat.pi * 2
        let circlePath = UIBezierPath.init(arcCenter: self.b_center, radius: self.width * 0.5 - lineWid, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        circleLayer.path = circlePath.cgPath
        
        circleLayer.frame = self.bounds
        circleLayer.lineWidth = lineWid
        circleLayer.lineCap = kCALineCapRound
        circleLayer.strokeColor = selColor.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(circleLayer)
        self.p_updateProgress(from: 0, to: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

