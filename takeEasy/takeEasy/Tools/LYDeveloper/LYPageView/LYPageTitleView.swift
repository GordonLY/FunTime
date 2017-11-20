//
//  LYPageTitleView.swift
//  i行销
//
//  Created by Gordon on 2017/6/29.
//  Copyright © 2017年 taikanglife. All rights reserved.
//

import UIKit


class LYPageTitleView: UIView {

    enum LYIndicatorLengthType {
        case fixWid
        case autoByTitle
    }
    var indicatorType = LYIndicatorLengthType.fixWid
    var actionTitleOnClick: ((LYPageTitleView, Int) -> Void)?
    
    var titles: [String]
    
    init(frame: CGRect, titles:[String]) {
        self.titles = titles
        super.init(frame: frame)
    }
    
    
    
    
    
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
