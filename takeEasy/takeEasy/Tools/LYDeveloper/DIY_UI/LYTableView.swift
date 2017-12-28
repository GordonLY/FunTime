//
//  LYTableView.swift
//  泰行销
//
//  Created by Gordon on 2017/9/21.
//  Copyright © 2017年 taikanglife. All rights reserved.
//

import UIKit

class LYTableView: UITableView {

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
//        if #available(iOS 11.0, *) {
//            self.contentInsetAdjustmentBehavior = .never
//        }
        self.estimatedRowHeight = 0
        self.estimatedSectionHeaderHeight = 0
        self.estimatedSectionFooterHeight = 0
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
