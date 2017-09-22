//
//  LYNoDataView.swift
//  i行销
//
//  Created by Gordon on 2017/7/10.
//  Copyright © 2017年 taikanglife. All rights reserved.
//

import UIKit

class LYNoDataView: UIView {
    
    var tipsTitle = UILabel()
    var imgView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = false
        self.frame = CGRect.init(x: 0, y: 0, width: kScreenWid(), height: kScreenHei())
        self.backgroundColor = UIColor.white
        
        imgView = UIImageView.init(frame: CGRect.init(x: 0, y: kFitWid(150), width: kScreenWid(), height: kFitWid(120)))
        imgView.contentMode = .scaleAspectFit
        imgView.image = kNoDataTipImage()
        self.addSubview(imgView)
        
        tipsTitle.frame = CGRect.init(x: 0, y: imgView.bottom + kFitWid(12), width: kScreenWid(), height: kFitWid(20))
        tipsTitle.textColor = kMidTitleColor()
        tipsTitle.font = kRegularFitFont(size: 12)
        tipsTitle.textAlignment = .center
        self.addSubview(tipsTitle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension UITableView {
    static let noDataViewTag = 1212121
}
extension LYDevelop where Base: UITableView {
    
    func addNoDataView(tips: String) {
        let noDataView = LYNoDataView.init(frame: base.bounds)
        noDataView.backgroundColor = kBgColorF5()
        noDataView.tipsTitle.text = tips
        noDataView.isHidden = true
        noDataView.tag = UITableView.noDataViewTag
        base.addSubview(noDataView)
    }
    
    func setNoDataViewOffset(_ offsetY: CGFloat) {
        guard let noDataView = base.viewWithTag(UITableView.noDataViewTag) as? LYNoDataView else {
            return
        }
        noDataView.imgView.top = offsetY
        noDataView.tipsTitle.top = noDataView.imgView.bottom + kFitWid(12)
    }
    func isNoDataHidden(_ hidden: Bool) {
        guard let noDataView = base.viewWithTag(UITableView.noDataViewTag) as? LYNoDataView else {
            return
        }
        noDataView.isHidden = hidden
    }
}



