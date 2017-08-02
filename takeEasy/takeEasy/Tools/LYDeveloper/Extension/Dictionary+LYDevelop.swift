//
//  Dictionary+LY.swift
//  teststttt
//
//  Created by Gordon on 2017/8/1.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit

extension Dictionary {
    
    static func +=(lhs: inout Dictionary<Key, Value>, rhs: Dictionary<Key, Value>)  {
        lhs.ly_merge(rhs)
    }
    mutating func ly_merge<S:Sequence>(_ sequence: S)
        where S.Iterator.Element == (key: Key, value: Value) {
            sequence.forEach { self[$0] = $1 }
    }
    
    
}
