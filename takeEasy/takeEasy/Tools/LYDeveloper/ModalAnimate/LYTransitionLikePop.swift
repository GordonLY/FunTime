//
//  LYTransitionLikePop.swift
//  i行销
//
//  Created by Gordon on 2017/6/26.
//  Copyright © 2017年 taikanglife. All rights reserved.
//

import UIKit

/// 要实现UIViewControllerAnimatedTransitioning协议就必须实现下面两个方法
class LYTransitionLikePop: NSObject, UIViewControllerAnimatedTransitioning {
   
    var offset: LYPushPopOffset
    
    init(transOffset: LYPushPopOffset) {
        self.offset = transOffset
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    /// 设置动画的进行方式，附有详细注释，demo中其他地方的这个方法不再解释
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        
        guard let fromView = fromVC?.view, let toView = toVC?.view else {
            d_print(">>>>>>>>>>> no animate view <<<<<<<<<<<<")
            return
        }
        // 设置动画的初始状态
        switch self.offset {
        case .short:
            toView.left = -150
        case .zero:
            break
        }
        
        let transitionDuration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: transitionDuration, animations: {
            fromView.left = kScreenWid()
            toView.left = 0
        }) { (finished) in
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
        }
    }
}
