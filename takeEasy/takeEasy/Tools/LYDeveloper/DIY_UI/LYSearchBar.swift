//
//  LYSearchBar.swift
//  i行销
//
//  Created by Gordon on 2017/6/26.
//  Copyright © 2017年 taikanglife. All rights reserved.
//

import UIKit

class LYSearchBar: UITextField {

    var placeholderColor = kSeparateLineColor()
    var placeholderTxt = "" {
        didSet {
            self.attributedPlaceholder = placeholderTxt.ly_AttributeStr(font: self.font ?? kRegularFitFont(size: 11), color: self.placeholderColor, wordSpacing: 0)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.borderStyle = .none
        self.returnKeyType = .search
        self.autocorrectionType = .no
        self.enablesReturnKeyAutomatically = true
    }
    
    func p_actionClearBtn() {
        self.text = ""
        self.sendActions(for: .editingChanged)
    }
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        guard self.isFirstResponder else {
            return CGRect.zero
        }
        guard let txt = self.text, txt.characters.count > 0 else {
            return CGRect.zero
        }
        return CGRect.init(x: self.width - self.height, y: 0, width: self.height, height: self.height)
    }
    private var rightBtn: UIButton!
    var ly_clearMode = false {
        didSet {
            guard ly_clearMode else {
                return
            }
            rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: self.height, height: self.height))
            rightBtn.addTarget(self, action: #selector(p_actionClearBtn), for: .touchUpInside)
            rightBtn.imageView?.contentMode = .center
            rightBtn.setImage(UIImage.init(named: "jz_search_clear"), for: .normal)
            rightBtn.setImage(UIImage.init(named: "jz_search_clear")?.lyImage(tintColor: UIColor.init(white: 1, alpha: 0.4)), for: .highlighted)
            self.rightView = rightBtn
            self.rightViewMode = .whileEditing
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
