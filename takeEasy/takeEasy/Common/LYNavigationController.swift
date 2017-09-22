//
//  LYNavigationController.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/2.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit

class LYNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置导航栏字体大小及颜色
        self.navigationBar.titleTextAttributes =
            [.font: kNaviFont(),
             .foregroundColor: kTitleColor()]
        
        self.navigationBar.ly.setNavBar(bgColor: UIColor.white, shadowColor: kSeparateLineColor())
    }
    
    // 监听即将进入的controller
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            
            viewController.hidesBottomBarWhenPushed = true
            let item = UIBarButtonItem()
            item.customView = self.p_createBackBtn()
            viewController.navigationItem.leftBarButtonItem = item;
        }
        super.pushViewController(viewController, animated: animated)
        self.interactivePopGestureRecognizer?.delegate = viewController as? UIGestureRecognizerDelegate
    }
    
    @objc func p_backBtnOnClick() {
        self.popViewController(animated: true)
    }
    private func p_createBackBtn() -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44)
        btn.contentHorizontalAlignment = .left
        btn.setImage(UIImage.init(named: "common_back"), for: .normal)
        btn.setImage(UIImage.init(named: "common_back")?.ly_image(tintColor: UIColor.init(white: 0, alpha: 0.5)), for: .highlighted)
        btn.addTarget(self, action: #selector(p_backBtnOnClick), for: .touchUpInside)
        return btn
    }
}
