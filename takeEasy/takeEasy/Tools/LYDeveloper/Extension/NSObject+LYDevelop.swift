//
//  NSObject+LYDevelop.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/3.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import Foundation
import YYModel

extension NSObject {
    
    ///  字典数组 -> 模型数组
    ///
    /// - Parameter keyValues: 字典数组
    ///
    /// - Returns: 模型数组
    class func ly_objArray(with keyValues: [[String: Any]]) -> [Any?] {
        
        var modelsArr = [Any?]()
        for kv in keyValues {
            modelsArr.append(self.yy_model(with: kv))
        }
        return modelsArr
    }
    
}
