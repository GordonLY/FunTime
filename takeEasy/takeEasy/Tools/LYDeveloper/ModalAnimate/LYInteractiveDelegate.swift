//
//  LYInteractiveDelegate.swift
//  i行销
//
//  Created by Gordon on 2017/6/28.
//  Copyright © 2017年 taikanglife. All rights reserved.
//

import UIKit

class LYInteractiveDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var gestureRecognizer: UIScreenEdgePanGestureRecognizer? = nil
    var targetEdge: UIRectEdge = UIRectEdge()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return LYInteractiveAnimator(targetEdge: targetEdge)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return LYInteractiveAnimator(targetEdge: targetEdge)
    }

    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if let gestureRecognizer = self.gestureRecognizer {
            return LYInteractiveController(gestureRecognizer: gestureRecognizer, edgeForDragging: targetEdge)
        }
        return nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if let gestureRecognizer = self.gestureRecognizer {
            return LYInteractiveController(gestureRecognizer: gestureRecognizer, edgeForDragging: targetEdge)
        }
        return nil
    }
}
