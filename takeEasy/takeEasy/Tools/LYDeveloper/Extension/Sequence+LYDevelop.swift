//
//  Sequence+LYDevelop.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/30.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import Foundation

extension Sequence {
    
    func all(predicate: (Iterator.Element) -> Bool) -> Bool {
        for x in self where !predicate(x) {
            return false
        }
        return true
    }
    
}

