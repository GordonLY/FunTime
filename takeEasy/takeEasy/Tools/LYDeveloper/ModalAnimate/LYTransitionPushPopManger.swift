//
//  LYTransitionPushPopManger.swift
//  i行销
//
//  Created by Gordon on 2017/6/26.
//  Copyright © 2017年 taikanglife. All rights reserved.
//

import UIKit

enum LYPushPopOffset {
    case short
    case zero
}

class LYTransitionPushPopManger: NSObject, UIViewControllerTransitioningDelegate {
    
    var transitionOffset = LYPushPopOffset.short
    
    static let shared = LYTransitionPushPopManger()
    private override init() {}
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return LYTransitionLikePush(transOffset: transitionOffset)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return LYTransitionLikePop(transOffset: transitionOffset)
    }
}
