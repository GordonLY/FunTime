//
//  UINavigationBar+LYDevelop.swift
//  kemiBear
//
//  Created by 李扬 on 2017/4/18.
//  Copyright © 2017年 李扬. All rights reserved.
//

import UIKit

extension LYDevelop where Base: UINavigationBar {
    
    func setNavBar(bgColor:UIColor, shadowColor:UIColor) {
        base.isTranslucent = true;
        let shadowImg = UIImage.ly_image(color: shadowColor, size: CGSize.init(width: kScreenWid(), height: 0.5), cornerRadius: 0)
        let bgImg = UIImage.ly_image(color: bgColor, size: CGSize.init(width: kScreenWid(), height: 64), cornerRadius: 0)
        base.shadowImage = shadowImg
        base.setBackgroundImage(bgImg, for: .default)
    }
    
    /// 将导航栏设置全透明   注意 设置之后可能会改变 UIframe的 Y 值
    func setNavBarFullClear() {
        
        base.isTranslucent = true;
        base.shadowImage = UIImage.ly_image(color: UIColor.init(white: 0, alpha: 0), size: CGSize.init(width: kScreenWid(), height: 0.5), cornerRadius: 0)
        base.setBackgroundImage(UIImage.ly_image(color: UIColor.init(white: 0, alpha: 0), size: CGSize.init(width: kScreenWid(), height: 64), cornerRadius: 0), for: .default)
    }
    
    
    /// 改变导航栏的字体，颜色，背景色
    /// ## 只在fullclear下使用
    /// - Parameter font: navTitle的字体
    ///
    /// - Parameter titleColor: navTitle的文字颜色
    ///
    /// - Parameter barBgColor: navBar的背景色
    func updateNavBar(font:UIFont, titleColor:UIColor, barBgColor: UIColor) {
        
        base.titleTextAttributes =
            [.font: font,
             .foregroundColor: titleColor]
        base.backgroundColor = barBgColor
    }
    
}

