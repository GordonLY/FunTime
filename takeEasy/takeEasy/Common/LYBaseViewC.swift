//
//  LYBaseViewC.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/2.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit

class LYBaseViewC: UIViewController, UIGestureRecognizerDelegate, LYRequestManagerDelegate {
    
    
    lazy var netMng: LYRequestManager = {
        let net = LYRequestManager()
        net.delegate = self
        return net
    }()
    lazy var animateView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        indicator.centerX = self.view.centerX
        indicator.top = kFitWid(200)
        self.isLoadAnimate = true
        self.view.addSubview(indicator)
        return indicator
    }()
    private var isLoadAnimate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isLoadAnimate {
            self.ly_stopAnimating()
        }
    }
    deinit {
        d_print("==== \(self) >>> dealloc ")
    }
    
    
    func ly_startAnimating() {
        animateView.superview?.bringSubview(toFront: animateView)
        animateView.startAnimating()
    }
    func ly_stopAnimating() {
        animateView.stopAnimating()
    }
    
    // MARK: - ********* Net Response delegate
    func lyNetworkReponseSucceed(urlStr: String, result: Dictionary<String, Any>?) {
    }
    func lyNetworkReponseIncorrectParam(urlStr: String, code: Int, message: String?) {
    }
    func lyNetworkReponseFailed(urlStr: String, error: Error?) {
        
    }
}
