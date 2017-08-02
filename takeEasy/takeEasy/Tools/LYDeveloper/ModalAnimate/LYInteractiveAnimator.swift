//
//  LYInteractiveAnimator.swift
//  i行销
//
//  Created by Gordon on 2017/6/28.
//  Copyright © 2017年 taikanglife. All rights reserved.
//

import UIKit

class LYInteractiveAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let targetEdge: UIRectEdge
    
    init(targetEdge: UIRectEdge) {
        self.targetEdge = targetEdge
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        
        guard let fromVc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
                let toVc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
                    let fromView = fromVc.view,
                        let toView = toVc.view else {
                            return
        }
        let containerView = transitionContext.containerView
     
        /// isPresenting用于判断当前是present还是dismiss
        let isPresenting = (toVc.presentingViewController == fromVc)
        let fromFrame = transitionContext.initialFrame(for: fromVc)
        let toFrame = transitionContext.finalFrame(for: toVc)
        
        /// offset结构体将用于计算toView的位置
        let offset: CGVector
        switch self.targetEdge {
        case UIRectEdge.top:
            offset = CGVector(dx: 0, dy: 1)
        case UIRectEdge.bottom:
            offset = CGVector(dx: 0, dy: -1)
        case UIRectEdge.left:
            offset = CGVector(dx: 1, dy: 0)
        case UIRectEdge.right:
            offset = CGVector(dx: -1, dy: 0)
        default:fatalError("targetEdge must be one of UIRectEdgeTop, UIRectEdgeBottom, UIRectEdgeLeft, or UIRectEdgeRight.")
        }
        
        let coverView = UIView.init(frame: CGRect.init(x: -kScreenWid(), y: 0, width: kScreenWid(), height: kScreenHei()))
        coverView.backgroundColor = UIColor.init(white: 0, alpha: 0.6)
        /// 根据当前是dismiss还是present，横屏还是竖屏，计算好toView的初始位置以及结束位置
        if isPresenting {
            fromView.frame = fromFrame
            toView.frame = toFrame.offsetBy(dx: toFrame.size.width * offset.dx * -1,
                                             dy: toFrame.size.height * offset.dy * -1)
            containerView.addSubview(toView)
            toView.addSubview(coverView)
        } else {
            fromView.frame = fromFrame
            toView.frame = toFrame
            fromView.addSubview(coverView)
        }
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: { () -> Void in
            if isPresenting {
                toView.frame = toFrame
            } else {
                fromView.frame = fromFrame.offsetBy(dx: fromFrame.size.width * offset.dx,
                                                     dy: fromFrame.size.height * offset.dy)
            }
        }, completion: { (finished: Bool) -> Void in
            coverView.removeFromSuperview()
            let wasCanceled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCanceled)
        })
    }
}
