//
//  LYTransitionLikePush.swift
//  i行销
//
//  Created by Gordon on 2017/6/26.
//  Copyright © 2017年 taikanglife. All rights reserved.
//

import UIKit

/// 要实现UIViewControllerAnimatedTransitioning协议就必须实现下面两个方法
class LYTransitionLikePush: NSObject, UIViewControllerAnimatedTransitioning {
    
    
    var offset: LYPushPopOffset
    
    init(transOffset: LYPushPopOffset) {
        self.offset = transOffset
    }
    
    /// 设置动画的持续时间
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
        toView.frame = CGRect(x: fromView.width, y: fromView.top, width: fromView.width, height: fromView.height)
        
        // 在present和，dismiss时，必须将toview添加到视图层次中
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        
        let transitionDuration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: transitionDuration, animations: {
            switch self.offset {
            case .short:
                fromView.left = -150
            case .zero:
                break
            }
            toView.left = 0
        }) { (finished) in
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
        }
    }
}


