//
//  LYHitTestView.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/2.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit

class LYHitTestScrollView: UIScrollView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        guard let currentView = view else {
            return view
        }
        if currentView.isKind(of: UITextView.self) || currentView.isKind(of: UITextField.self) ||
            currentView.isKind(of: UIButton.self) {
            return currentView
        } else {
            self.endEditing(true)
            return currentView
        }
    }
}

class LYHitTestTableView: UITableView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        guard let currentView = view else {
            return view
        }
        if currentView.isKind(of: UITextView.self) || currentView.isKind(of: UITextField.self) || currentView.isKind(of: UIButton.self) {
            return currentView
        } else {
            self.endEditing(true)
            return view
        }
    }
}
