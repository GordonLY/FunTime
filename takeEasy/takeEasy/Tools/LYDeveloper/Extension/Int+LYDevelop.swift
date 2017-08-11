//
//  Int+LYDevelop.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/10.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import Foundation

extension LYDevelop where Base == Int {
    func toTimeString() -> String {
        
        let seconds = base
        let hour_str = String.init(format: "%02d", seconds/3600)
        let minute_str = String.init(format: "%02d", (seconds%3600)/60)
        let second_str = String.init(format: "%02d", seconds%60)
        if hour_str == "00" {
            return "\(minute_str):\(second_str)"
        }
        return "\(hour_str):\(minute_str):\(second_str)"
    }
}
