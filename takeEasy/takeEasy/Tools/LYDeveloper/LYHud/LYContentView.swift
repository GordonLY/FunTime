//
//  LYContentView.swift
//  泰行销
//
//  Created by Gordon on 2017/10/18.
//  Copyright © 2017年 taikanglife. All rights reserved.
//

import UIKit

class LYContentView: UIView {
    
    private var containerView: UIView!
    private var bgView:   UIView!
    
    /// 外部调用此方法，把要显示的view传入
    func setContentView(_ showView: UIView?) {
        containerView.subviews.forEach { $0.removeFromSuperview() }
        guard let view = showView else {
            return
        }
        view.ly_origin = CGPoint.zero
        containerView.ly_size = view.ly_size
        containerView.addSubview(view)
    }
    
    // MARK: - ********* Publick Method
    func show() {
        let keyWindow = UIApplication.shared.keyWindow
        containerView.top = self.height
        self.backgroundColor = UIColor.init(white: 0, alpha: 0)
        keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = UIColor.init(white: 0, alpha: 0.6)
            self.containerView.top = self.height - self.containerView.height - kBtmSafeHei()
        }
    }
    func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = UIColor.init(white: 0, alpha: 0)
            self.containerView.top = self.height
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    @objc fileprivate func p_actionTapGesture(tap: UITapGestureRecognizer) {
        self.hide()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect.init(x: 0, y: 0, width: kScreenWid(), height: kScreenHei())
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.6)
        self.p_initSubviews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LYContentView {
    
    fileprivate func p_initSubviews() {
        
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(p_actionTapGesture(tap:))))
        
        containerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWid(), height: kScreenHei()))
        containerView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(p_toStopGesture)))
        self.addSubview(containerView)
    }
    @objc fileprivate func p_toStopGesture() {
        
    }
    
}
