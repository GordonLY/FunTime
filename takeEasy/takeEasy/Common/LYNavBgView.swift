//
//  LYNavBgView.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/2.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit

class LYNavBgView: UIView {
    
    var titleLabel: UILabel!
    var leftClickCallBack: (() -> Void)?
    var rightClickCallBack: (() -> Void)?
    
    enum BgViewLeftStyle {
        case back
        case close
    }
    enum BgViewRightStyle {
        case share
    }
    
    private var leftView: UIButton!
    private var rightView: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = CGRect.init(x: 0, y: 0, width: kScreenWid(), height: 64)
        self.backgroundColor = UIColor.white
        
        
        let line = UIView.init(frame: CGRect.init(x: 0, y: 63.5, width: kScreenWid(), height: 0.5))
        line.backgroundColor = kSeparateLineColor()
        self.addSubview(line)
        
        titleLabel = UILabel.init(frame: CGRect.init(x: 48, y: 20, width: kScreenWid() - 96, height: 44))
        titleLabel.textColor = kTitleColor()
        titleLabel.textAlignment = .center
        titleLabel.font = kStandardRegualrFont(size: 17)
        self.addSubview(titleLabel)
        
        leftView = UIButton.init(frame: CGRect.init(x: 0, y: 20, width: 48, height: 44))
        leftView.setImage(UIImage.init(named: "km_back"), for: .normal)
        leftView.setImage(UIImage.init(named: "km_back")?.lyImage(tintColor: kTitleColorHalf()), for: .highlighted)
        leftView.isHidden = true
        leftView.addTarget(self, action: #selector(p_ActionleftView), for: .touchUpInside)
        self.addSubview(leftView)
        
        rightView = UIButton.init(frame: CGRect.init(x: kScreenWid() - 48, y: 20, width: 48, height: 44))
        rightView.setImage(UIImage.init(named: "share_icon"), for: .normal)
        rightView.setImage(UIImage.init(named: "share_icon")?.lyImage(tintColor: kTitleColorHalf()), for: .highlighted)
        rightView.isHidden = true
        rightView.addTarget(self, action: #selector(p_ActionRightView), for: .touchUpInside)
        self.addSubview(rightView)
    }
    
    func p_ActionleftView() {
        if (leftClickCallBack != nil) {
            leftClickCallBack!()
        }
    }
    func p_ActionRightView() {
        if (rightClickCallBack != nil) {
            rightClickCallBack!()
        }
    }
    
    
    func setLeftViewStyle(_ style: BgViewLeftStyle, callBack:@escaping () -> Void) {
        leftClickCallBack = callBack
        switch style {
        case .back:
            leftView.setImage(UIImage.init(named: "km_back"), for: .normal)
            leftView.setImage(UIImage.init(named: "km_back")?.lyImage(tintColor: kSubTitleColorHalf()), for: .highlighted)
        case .close:
            leftView.setImage(UIImage.init(named: "home_close"), for: .normal)
            leftView.setImage(UIImage.init(named: "home_close")?.lyImage(tintColor: kSubTitleColorHalf()), for: .highlighted)
        }
        leftView.isHidden = false
    }
    
    func setRightViewStyle(_ style: BgViewRightStyle, callBack:@escaping () -> Void) {
        rightClickCallBack = callBack
        rightView.isHidden = false
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
