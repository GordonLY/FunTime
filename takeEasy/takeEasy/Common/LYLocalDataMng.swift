//
//  LYLocalDataMng.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/2.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit

class LYLocalDataMng: NSObject {
    
    static let shared = LYLocalDataMng()
    private override init() {}
    
    // MARK: - ********* 存储的数据
    var token: String {
        get {
            guard let str = UserDefaults.standard.string(forKey: "ly_takeEasy_token") else {
                return ""
            }
            return str
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "ly_takeEasy_token")
            UserDefaults.standard.synchronize()
        }
    }

}
