//
//  LYAlertView.swift
//  kemiBear
//
//  Created by 李扬 on 2017/3/26.
//  Copyright © 2017年 lanrun. All rights reserved.
//

import UIKit

enum LYAlertOption {
    case confirm
    case cancel
}

class LYAlertView: UIView {
    
    private var contain: UIView!
    private var label: UILabel!
    
    private var btnContain: UIView!
    private var btnYes: LYFrameButton!
    private var btnNo: LYFrameButton!
    
    private var okBtn: LYFrameButton!
    
    private var completeCallBack:((LYAlertOption) -> Void)?
    private var okBtnCallBack:(() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.p_initSubviews()
    }
    
    class public func show(title:String, confirm:String, cancel:String, onComplete:((LYAlertOption) -> Void)?) {
        
        let shareAlert = LYAlertView.init(frame: (UIApplication.shared.keyWindow?.bounds)!)
        shareAlert.completeCallBack = onComplete
        shareAlert.label.text = title
        shareAlert.btnYes.setTitle(confirm, for: .normal)
        shareAlert.btnNo.setTitle(cancel, for: .normal)
        
        shareAlert.btnYes.isHidden = false
        shareAlert.btnNo.isHidden = false
        shareAlert.okBtn.isHidden = true
        
        let view = UIApplication.shared.keyWindow
        if shareAlert.superview != view {
            shareAlert.removeFromSuperview()
            view?.addSubview(shareAlert)
        }
        shareAlert.p_show()
    }
    class public func showTip(attrTitle:NSAttributedString, know:String, onComplete: (() -> Void)?) {
        
        let shareAlert = LYAlertView.init(frame: (UIApplication.shared.keyWindow?.bounds)!)
        shareAlert.okBtnCallBack = onComplete
        shareAlert.label.attributedText = attrTitle
        shareAlert.okBtn.setTitle(know, for: .normal)
        shareAlert.btnYes.isHidden = true
        shareAlert.btnNo.isHidden = true
        shareAlert.okBtn.isHidden = false
        
        let view = UIApplication.shared.keyWindow
        if shareAlert.superview != view {
            shareAlert.removeFromSuperview()
            view?.addSubview(shareAlert)
        }
        shareAlert.p_show()
    }
    
    
    
    // MARK: - ********* Private Method
    // MARK: *** 点击整个页面
    func p_viewOnTap(tap: UITapGestureRecognizer) {
        
    }
    // MARK: *** 点击 确定
    @objc func p_confirmOnClick() {
        if completeCallBack != nil {
            completeCallBack!(.confirm)
        }
        self.p_hide()
    }
    // MARK: *** 点击 取消
    @objc func p_cancelOnClick() {
        if completeCallBack != nil {
            completeCallBack!(.cancel)
        }
        self.p_hide()
    }
    // MARK: *** 点击 我知道了
    @objc func p_okBtnOnClick() {
        if okBtnCallBack != nil {
            okBtnCallBack!()
        }
        self.p_hide()
    }
    
    func p_show() {
        if (self.superview == nil) {
            return;
        }
        contain.transform = .init(scaleX: 0.5, y: 0.5)
        contain.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.3, options: .curveLinear, animations: {
            self.contain.transform = .identity
            self.contain.alpha = 1
            self.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        }) { (finished) in
            
        }
    }
    func p_hide() {
        if (self.superview == nil) {
            return;
        }
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.3, options: .curveLinear, animations: {
            self.contain.transform = .init(scaleX: 0.5, y: 0.5)
            self.contain.alpha = 0
            self.backgroundColor = UIColor.init(white: 0, alpha: 0)
        }) { (finished) in
                self.removeFromSuperview()
        }
    }
    func p_initSubviews() {
        
        self.backgroundColor = UIColor.init(white: 0, alpha: 0)

//        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(p_viewOnTap(tap:)))
//        self.addGestureRecognizer(tapGesture)
        
        contain = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kFitWid(260), height: kFitWid(160)))
        contain.backgroundColor = UIColor.white
        contain.layer.ly.setCornerRadius(kFitWid(5))
        self.addSubview(contain)
        contain.center = self.center
        
        label = UILabel.init(frame: CGRect.init(x: 15, y: kFitWid(10), width: contain.width - 30, height: kFitWid(90)))
        label.numberOfLines = 3
        label.font = kRegularFitFont(size: 14)
        label.textColor = kMidTitleColor()
        label.textAlignment = .center
        contain.addSubview(label)
        
        btnContain = UIView.init(frame: CGRect.init(x: 0, y: label.bottom, width: contain.width, height: kFitWid(40)))
        contain.addSubview(btnContain)
        
        let btnW = kFitWid(100)
        let btnH = kFitWid(30)
        
        btnYes = LYFrameButton.init(type: .custom)
        btnYes.frame = CGRect.init(x: contain.width - btnW - kFitWid(20), y: 0, width: btnW, height: btnH)
        btnYes.layer.ly.setCornerRadius(kFitWid(5))
        btnYes.backgroundColor = kThemeColor()
        btnYes.titleLabel?.font = kRegularFitFont(size: 14)
        btnYes.setTitleColor(UIColor.white, for: .normal)
        btnYes.setTitleColor(UIColor.init(white: 1, alpha: 0.5), for: .highlighted)
        btnYes.setTitle("是", for: .normal)
        btnYes.addTarget(self, action: #selector(p_confirmOnClick), for: .touchUpInside)
        btnContain.addSubview(btnYes)
        
        btnNo = LYFrameButton.init(type: .custom)
        btnNo.frame = CGRect.init(x: kFitWid(20), y: 0, width: btnW, height: btnH)
        btnNo.layer.ly.setCornerRadius(kFitWid(5))
        btnNo.layer.borderColor = kThemeColor().cgColor
        btnNo.layer.borderWidth = 0.5
        btnNo.isBorderAnimate = true
        btnNo.titleLabel?.font = kRegularFitFont(size: 14)
        btnNo.setTitleColor(kThemeColor(), for: .normal)
        btnNo.setTitleColor(kThemeColorHalf(), for: .highlighted)
        btnNo.setTitle("否", for: .normal)
        btnNo.addTarget(self, action: #selector(p_cancelOnClick), for: .touchUpInside)
        btnContain.addSubview(btnNo)
        
        okBtn = LYFrameButton.init(type: .custom)
        okBtn.frame = CGRect.init(x: 0, y: 0, width: kFitWid(110), height: btnH)
        okBtn.centerX = btnContain.width * 0.5
        okBtn.layer.ly.setCornerRadius(kFitWid(5))
        okBtn.backgroundColor = kThemeColor()
        okBtn.titleLabel?.font = kRegularFitFont(size: 15)
        okBtn.setTitleColor(UIColor.white, for: .normal)
        okBtn.setTitleColor(UIColor.init(white: 1, alpha: 0.5), for: .highlighted)
        okBtn.isHidden = true
        okBtn.setTitle("我知道了", for: .normal)
        okBtn.addTarget(self, action: #selector(p_okBtnOnClick), for: .touchUpInside)
        btnContain.addSubview(okBtn)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class LYShowView: UIView {
    
    private var contain: UIView!
    private var imgView: UIImageView!
    private var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.p_initSubviews()
    }
    
    class public func showSuccess(title:String) {
        
        let shareAlert = LYShowView.init(frame: (UIApplication.shared.keyWindow?.bounds)!)
        shareAlert.label.text = title
        shareAlert.imgView.image = UIImage.init(named: "alert_success")
        
        let view = UIApplication.shared.keyWindow
        if shareAlert.superview != view {
            shareAlert.removeFromSuperview()
            view?.addSubview(shareAlert)
        }
        shareAlert.p_show()
    }
    
    
    // MARK: - ********* Private Method
    // MARK: *** 点击整个页面
    @objc func p_viewOnTap(tap: UITapGestureRecognizer) {
        self.p_hide()
    }
    
    func p_show() {
        if (self.superview == nil) {
            return;
        }
        contain.transform = .init(scaleX: 0.5, y: 0.5)
        contain.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.3, options: .curveLinear, animations: {
            self.contain.transform = .identity
            self.contain.alpha = 1
            self.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        }) { (finished) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: { 
                self.p_hide()
            })
        }
    }
    func p_hide() {
        if (self.superview == nil) {
            return;
        }
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.3, options: .curveLinear, animations: {
            self.contain.transform = .init(scaleX: 0.5, y: 0.5)
            self.contain.alpha = 0
            self.backgroundColor = UIColor.init(white: 0, alpha: 0)
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    func p_initSubviews() {
        
        self.backgroundColor = UIColor.init(white: 0, alpha: 0)
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(p_viewOnTap(tap:)))
        self.addGestureRecognizer(tapGesture)
        
        contain = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kFitWid(144), height: kFitWid(144)))
        contain.backgroundColor = UIColor.white
        contain.layer.ly.setCornerRadius(kFitWid(5))
        self.addSubview(contain)
        contain.center = self.center
        
        imgView = UIImageView.init(frame: CGRect.init(x: 0, y: kFitWid(15), width: contain.width, height: kFitWid(89)))
        imgView.contentMode = .center
        contain.addSubview(imgView)
        
        label = UILabel.init(frame: CGRect.init(x: 15, y: imgView.bottom, width: contain.width - 30, height: kFitWid(15)))
//        label.numberOfLines = 1
        label.font = kRegularFitFont(size: 15)
        label.textColor = kTitleColor()
        label.textAlignment = .center
        contain.addSubview(label)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


