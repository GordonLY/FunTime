//
//  UINavigationBar+LYDevelop.swift
//  kemiBear
//
//  Created by 李扬 on 2017/4/18.
//  Copyright © 2017年 李扬. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    
    func lySetNavBar(bgColor:UIColor, shadowColor:UIColor) {
        self.isTranslucent = true;
        let shadowImg = UIImage.lyImage(color: shadowColor, size: CGSize.init(width: kScreenWid(), height: 0.5), cornerRadius: 0)
        let bgImg = UIImage.lyImage(color: bgColor, size: CGSize.init(width: kScreenWid(), height: 64), cornerRadius: 0)
        self.shadowImage = shadowImg
        self.setBackgroundImage(bgImg, for: .default)
    }
    
    /// 将导航栏设置全透明   注意 设置之后可能会改变 UIframe的 Y 值
    func lySetNavBarFullClear() {
        
        self.isTranslucent = true;
        self.shadowImage = UIImage.lyImage(color: UIColor.init(white: 0, alpha: 0), size: CGSize.init(width: kScreenWid(), height: 0.5), cornerRadius: 0)
        self.setBackgroundImage(UIImage.lyImage(color: UIColor.init(white: 0, alpha: 0), size: CGSize.init(width: kScreenWid(), height: 64), cornerRadius: 0), for: .default)
    }
    
    
    /// 改变导航栏的字体，颜色，背景色
    /// ## 只在fullclear下使用
    /// - Parameter font: navTitle的字体
    ///
    /// - Parameter titleColor: navTitle的文字颜色
    ///
    /// - Parameter barBgColor: navBar的背景色
    func lyUpdateNavBar(font:UIFont, titleColor:UIColor, barBgColor: UIColor) {
     
        self.titleTextAttributes =
        [NSFontAttributeName: font,
            NSForegroundColorAttributeName: titleColor]
        self.backgroundColor = barBgColor
    }
}
