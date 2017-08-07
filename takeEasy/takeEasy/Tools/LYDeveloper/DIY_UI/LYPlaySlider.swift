//
//  LYPlaySlider.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/7.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit


class LYPlaySlider: UIControl {

    var valueChanged: ((CGFloat) -> Void)?
    public var thumbImg = UIImage.ly_image(color: UIColor.white, size: CGSize.init(width: kFitCeilWid(12), height: kFitCeilWid(12)), cornerRadius: kFitCeilWid(12) * 0.5)
    public var thumbImgHighLight = UIImage.ly_image(color: UIColor.white, size: CGSize.init(width: kFitCeilWid(14), height: kFitCeilWid(14)), cornerRadius: kFitCeilWid(14) * 0.5)
    public func seekToTime(_ time: CGFloat) {
        var point_x = time
        if point_x < 0 {
            point_x = 0
        }
        else if point_x > self.width {
            point_x = self.width
        }
        self.value = point_x
    }
    
    // MARK: - ********* Action
    private var value:CGFloat = 0 {
        didSet {
            self.p_updateUI()
        }
    }
    func p_updateUI() {
        thumbView.centerX = self.value
        selView.width = thumbView.centerX
        if let valueChanged = valueChanged {
            valueChanged(self.value)
        }
    }
    
    // MARK: - ********* UIControl delegate
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let point_x = touch.location(in: self).x
        self.value = point_x
        return true
    }
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        var point_x = touch.location(in: self).x
        if point_x < 0 {
            point_x = 0
        }
        else if point_x > self.width {
            point_x = self.width
        }
        self.value = point_x
        return true
    }
    
    
    // MARK: - ********* Init view
    private let normalView = UIView()
    private let selView = UIView()
    private var thumbView: UIImageView!
    private var leftLabel: UILabel!
    private var rightLabel: UILabel!
    
    private let slider_y = kFitCeilWid(0)
    private let sliderHeight = kFitCeilWid(2)
    private let sliderNormoalColor = UIColor.ly_color(0x6e6b72)
    private let sliderSelColor = kThemeColor()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        normalView.frame = CGRect.init(x: 0, y: slider_y, width: self.width, height: sliderHeight)
        normalView.layer.ly.setRoundRect()
        normalView.backgroundColor = sliderNormoalColor
        normalView.isUserInteractionEnabled = false
        self.addSubview(normalView)
        
        selView.frame = CGRect.init(x: 0, y: slider_y, width: 0, height: sliderHeight)
        selView.layer.ly.setRoundRect()
        selView.backgroundColor = sliderSelColor
        selView.isUserInteractionEnabled = false
        self.addSubview(selView)
        
        thumbView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: kFitCeilWid(14), height: kFitCeilWid(14)))
        thumbView.centerX = 0
        thumbView.centerY = normalView.centerY
        thumbView.contentMode = .center
        thumbView.image = thumbImg
        self.addSubview(thumbView)
        
        leftLabel = UILabel.init(frame: CGRect.init(x: 0, y: thumbView.bottom, width: self.width * 0.5, height: kFitCeilWid(12)))
        leftLabel.textColor = kBgColorF5()
        leftLabel.font = kRegularFitFont(size: 11)
        leftLabel.text = "00:00"
        self.addSubview(leftLabel)
        
        rightLabel = UILabel.init(frame: CGRect.init(x: self.width * 0.5, y: thumbView.bottom, width: self.width * 0.5, height: kFitCeilWid(12)))
        rightLabel.textAlignment = .right
        rightLabel.textColor = kBgColorF5()
        rightLabel.font = kRegularFitFont(size: 11)
        rightLabel.text = "00:00"
        self.addSubview(rightLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


