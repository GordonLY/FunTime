//
//  LYPlayerOption.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/10.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit

class LYPlayerOption: NSObject {

    var isPlaying = false
    var currenTime: TimeInterval = 0
    var totalTime: TimeInterval = 0
    
    enum InterfaceOrientationType {
        case portrait           //home键在下面
        case portraitUpsideDown //home键在上面
        case landscapeLeft      //home键在左边
        case landscapeRight     //home键在右边
        case unknown            //未知方向
    }
    /// 屏幕方向
    var screenDirection: InterfaceOrientationType {
        let orientation = UIApplication.shared.statusBarOrientation
        switch orientation {
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        case .unknown:
            return .unknown
        }
    }

}
