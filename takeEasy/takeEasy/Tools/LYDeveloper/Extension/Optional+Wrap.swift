//
//  Optional+Wrap.swift
//  i行销
//
//  Created by Gordon on 2017/6/23.
//  Copyright © 2017年 taikanglife. All rights reserved.
//

import Foundation


///  Optional Wrap
extension Optional {
    func canWrap(_ body: (Wrapped) -> Void) {
        if let value = self {
            body(value)
        }
    }
}
