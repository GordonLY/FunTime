//
//  UIScrollView+EmptyTips.swift
//  泰行销
//
//  Created by Gordon on 2017/10/27.
//  Copyright © 2017年 taikanglife. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    private static var empty = "\0"
    fileprivate var emptyView: LYNoDataView? {
        return objc_getAssociatedObject(self, &UIScrollView.empty) as? LYNoDataView
    }
    
    func ly_empty(tips: NSAttributedString, image: UIImage? = nil, onClick: (() -> Void)? = nil) {
        let view = LYNoDataView.init(frame: self.bounds, tips: tips, image: image, onClick: onClick)
        view.backgroundColor = self.backgroundColor
        self.addSubview(view)
        self.bringSubview(toFront: view)
        view.isHidden = true
        objc_setAssociatedObject(self, &UIScrollView.empty, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func ly_empty(atPoint point: CGPoint) {
        guard let view = self.emptyView else {
            return
        }
        view.btn.ly_origin = point
    }
}
extension UITableView {
    /// 使用此方法来reloadData, reload完成后会根据数据源是否为空来显示emptyView
    func reloadWithEmptyView() {
        self.reloadData()
        guard let emptyView = self.emptyView else {
            return
        }
        var isEmpty = true
        for row in 0 ..< self.numberOfSections {
            if self.numberOfRows(inSection: row) > 0 {
                isEmpty = false
                break
            }
        }
        emptyView.isHidden = !isEmpty
    }
}
extension UICollectionView {
    /// 使用此方法来reloadData, reload完成后会根据数据源是否为空来显示emptyView
    func reloadWithEmptyView() {
        self.reloadData()
        guard let emptyView = self.emptyView else {
            return
        }
        var isEmpty = true
        for item in 0 ..< self.numberOfSections {
            if self.numberOfItems(inSection: item) > 0 {
                isEmpty = false
                break
            }
        }
        emptyView.isHidden = !isEmpty
    }
}

fileprivate class LYNoDataView: UIView {
    
    fileprivate var tips : NSAttributedString
    fileprivate var image: UIImage?
    fileprivate var tipsOnClick: (() -> Void)?
    
    fileprivate var btn: LYFrameButton!
    private let imgMarginTitle = kFitCeilWid(12)
    
    @objc private func p_actionTipsBtn() {
        if let clickAction = tipsOnClick {
            clickAction()
        }
    }
    
    init(frame: CGRect, tips: NSAttributedString, image: UIImage? = nil, onClick: (() -> Void)? = nil) {
        self.tips = tips
        self.image = image
        self.tipsOnClick = onClick
        super.init(frame: frame)
        
        let imgHei = image?.size.height ?? 0
        let titleHei = tips.size().height
        let btnHei = imgHei + titleHei + imgMarginTitle
        
        btn = LYFrameButton.init(frame: CGRect.init(x: 0, y: 0, width: self.width, height: btnHei))
        btn.center = CGPoint.init(x: self.middleX, y: self.middleY)
        btn.lyImageViewFrame = CGRect.init(x: 0, y: 0, width: btn.width, height: imgHei)
        btn.lyTitleLabelFrame = CGRect.init(x: 0, y: btn.height - titleHei, width: btn.width, height: titleHei)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.titleLabel?.textAlignment = .center
        
        btn.setImage(image, for: .normal)
        btn.setAttributedTitle(tips, for: .normal)
        btn.addTarget(self, action: #selector(p_actionTipsBtn), for: .touchUpInside)
        self.addSubview(btn)
        
        btn.isUserInteractionEnabled = onClick != nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
