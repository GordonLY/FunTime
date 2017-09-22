//
//  LYDevelopExtern.swift
//  kemiBear
//
//  Created by 李扬 on 2017/4/18.
//  Copyright © 2017年 李扬. All rights reserved.
//

//ipad 1:       1024×768像素。长宽比：1.33。
//ipad 2:       1024x768像素。
//ipad 3:       2048×1536像素。
//ipad 4:       2048×1536像素。
//ipad air:     2048×1536像素。
//ipad air2:    2048×1536像素。
//ipad mini:    1024×768像素。
//ipad mini2:   2048×1536像素。

//iphone 4/4s:               分辨率960*640，长宽比：1.5。
//iphone 5/5c/5s/se/6zoom:   分辨率1136*640，长宽比：1.775。
//iphone 6/6s/7/7s:          分辨率1334*750，长宽比：1.779。
//iphone 6+zoom/7+zoom:      分辨率2001*1125，长宽比：1.778。
//iphone 6+/7+:              分辨率2208*1242，长宽比：1.778。

import UIKit

class LYDevelopExtern: NSObject {
    
    class var shared : LYDevelopExtern {
        struct Static {
            static let instance = LYDevelopExtern()
        }
        return Static.instance
    }
    
    public var lyScreenWidth: CGFloat {
        self.p_refreshIfNeeded()
        return screenWidth
    }
    public var lyScreenHeight: CGFloat {
        self.p_refreshIfNeeded()
        return screenHeight
    }
    public var lyScreenWidthRatio: CGFloat {
        self.p_refreshIfNeeded()
        return screenWidthRatio
    }
    public var lyScreenHeightRatio: CGFloat {
        self.p_refreshIfNeeded()
        return screenHeightRatio
    }
    

    private func p_refreshIfNeeded() {
        guard UIScreen.main.bounds.size.equalTo(CGSize(width: screenWidth, height: screenHeight)) else {
            self.p_refreshData()
            return
        }
    }

    //  默认参考size = (375,667)
    private let designSize = CGSize.init(width: 375, height: 667)
    private var screenWidth: CGFloat = 1
    private var screenHeight: CGFloat = 1
    private var screenWidthRatio: CGFloat = 1
    private var screenHeightRatio: CGFloat = 1
    private func p_refreshData() {
        screenWidth = UIScreen.main.bounds.size.width
        screenHeight = UIScreen.main.bounds.size.height
        screenWidthRatio = screenWidth / designSize.width
        screenHeightRatio = screenHeight / designSize.height
    }
}
