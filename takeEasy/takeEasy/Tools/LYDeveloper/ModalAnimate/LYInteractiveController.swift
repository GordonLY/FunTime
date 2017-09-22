//
//  LYInteractiveController.swift
//  i行销
//
//  Created by Gordon on 2017/6/28.
//  Copyright © 2017年 taikanglife. All rights reserved.
//

import UIKit

class LYInteractiveController: UIPercentDrivenInteractiveTransition {
    var transitionContext: UIViewControllerContextTransitioning? = nil
    var gestureRecognizer: UIScreenEdgePanGestureRecognizer
    var edge: UIRectEdge
    
    init(gestureRecognizer: UIScreenEdgePanGestureRecognizer, edgeForDragging edge: UIRectEdge) {
        assert(edge == .top || edge == .bottom || edge == .left || edge == .right,
               "edgeForDragging must be one of UIRectEdgeTop, UIRectEdgeBottom, UIRectEdgeLeft, or UIRectEdgeRight.")
        self.gestureRecognizer = gestureRecognizer
        self.edge = edge
        
        super.init()
        self.gestureRecognizer.addTarget(self, action: #selector(gestureRecognizeDidUpdate(_:)))
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        super.startInteractiveTransition(transitionContext)
    }
    
    /**
     用于根据计算动画完成的百分比
     
     :param: gesture 当前的滑动手势，通过这个手势获取滑动的位移
     
     :returns: 返回动画完成的百分比
     */
    fileprivate func percentForGesture(_ gesture: UIScreenEdgePanGestureRecognizer) -> CGFloat {
        
        guard let containerView = transitionContext?.containerView else {
            return 0
        }
        let locationView = gesture.location(in: containerView)
        let width = containerView.width
        let height = containerView.height
        
        switch self.edge {
        case UIRectEdge.right:
            return (width - locationView.x) / width
        case UIRectEdge.left:
            return locationView.x / width
        case UIRectEdge.bottom:
            return (height - locationView.y) / height
        case UIRectEdge.top:
            return locationView.y / height
        default:
            return 0
        }
    }
    
    /// 当手势有滑动时触发这个函数
    @objc func gestureRecognizeDidUpdate(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            break
        case .changed:  //手势滑动，更新百分比
            self.update(self.percentForGesture(gestureRecognizer))
        case .ended:    // 滑动结束，判断是否超过一半，如果是则完成剩下的动画，否则取消动画
            if self.percentForGesture(gestureRecognizer) >= 0.5 {
                self.finish()
            }
            else {
                self.cancel()
            }
        default:
            self.cancel()
        }
    }
}
