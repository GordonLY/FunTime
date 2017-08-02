//
//  LYHudView.swift
//  kemiBear
//
//  Created by 李扬 on 2017/3/2.
//  Copyright © 2017年 lanrun. All rights reserved.
//

import UIKit
import MBProgressHUD

class LYToastView: NSObject {
    
    class func showLoading() {
       
        let vc = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        var showView  = vc?.viewControllers.last?.view

        if showView == nil {
            showView = UIApplication.shared.keyWindow
        }
        let hud = MBProgressHUD.init(view: showView!)
        hud.bezelView.alpha = 1
        hud.bezelView.layer.cornerRadius = 10
        hud.bezelView.color = UIColor.init(white: 0, alpha: 0.8)
        hud.bezelView.style = .solidColor
        
        if #available(iOS 9.0, *) {
            UIActivityIndicatorView.appearance(whenContainedInInstancesOf: [MBProgressHUD.self]).color = UIColor.white
        } else {
            hud.activityIndicatorColor = UIColor.white
        }
        hud.removeFromSuperViewOnHide = true
        hud.animationType = .fade
        showView?.addSubview(hud)
        DispatchQueue.main.async {
            hud.show(animated: true)
        }
    }
    
    class func hideLoading() {
        let vc = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        var hideView = vc?.viewControllers.last?.view
        if hideView == nil {
            hideView = UIApplication.shared.keyWindow
        }
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: hideView!, animated: true)
        }
    }

    class func showMessage(_ message: Any?) {
        guard let message = message as? String else {
            return
        }
        let view = UIApplication.shared.keyWindow ?? UIView()
        
        let hud = MBProgressHUD.init(view: view)
       
        hud.mode = .text
        hud.label.text = message
        hud.label.font = kRegularFitFont(size: 11)
        hud.label.textColor = UIColor.white
        
        hud.margin = 8
        hud.bezelView.alpha = 1
        hud.bezelView.layer.cornerRadius = kFitCeilWid(5)
        hud.bezelView.color = UIColor.init(white: 0, alpha: 0.8)
        hud.bezelView.style = .solidColor
        
        hud.isUserInteractionEnabled = false
        hud.removeFromSuperViewOnHide = true
        hud.offset.y = kFitCeilWid(100)
        hud.animationType = .fade
        
        view.addSubview(hud)
        DispatchQueue.main.async {
            hud.show(animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { 
            hud.hide(animated: true)
        }
    }
    
    
    class func showLoadingIn(view: UIView?) {
        
        guard let showView = view else {
            self.showLoading()
            return
        }
        
        let hud = MBProgressHUD.init(view: showView)
        hud.bezelView.alpha = 1
        hud.bezelView.layer.cornerRadius = 10
        hud.bezelView.color = UIColor.init(white: 0, alpha: 0.8)
        hud.bezelView.style = .solidColor
        
        if #available(iOS 9.0, *) {
            UIActivityIndicatorView.appearance(whenContainedInInstancesOf: [MBProgressHUD.self]).color = UIColor.white
        } else {
            hud.activityIndicatorColor = UIColor.white
        }
        hud.removeFromSuperViewOnHide = true
        hud.animationType = .fade
        showView.addSubview(hud)
        DispatchQueue.main.async {
            hud.show(animated: true)
        }
    }
    class func hideLoadingIn(view: UIView?) {
        guard let hideView = view else {
            self.hideLoading()
            return
        }
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: hideView, animated: true)
        }
    }
    
    
}
