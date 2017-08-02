//
//  LYRefreshFooter.swift
//  kemiBear
//
//  Created by 李扬 on 2017/4/19.
//  Copyright © 2017年 李扬. All rights reserved.
//

import UIKit
import MJRefresh

class LYRefreshFooter: MJRefreshBackFooter {

    public func setTitle(_ title:String?, for state:MJRefreshState) -> Void {
        if let title = title {
            stateTitles[state] = title
        }
    }
    
    private var loading: UIActivityIndicatorView!
    private var stateLabel: UILabel!
    private var stateTitles = [MJRefreshState: String?]()
    
    override func prepare() {
        super.prepare()
        
        self.mj_h = 50
        
        loading = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        loading.hidesWhenStopped = false
        self.addSubview(loading)
        
        stateLabel = UILabel()
        stateLabel.textAlignment = .center
        stateLabel.textColor = kMidTitleColor()
        stateLabel.font = kRegularFitFont(size: 14)
        stateLabel.backgroundColor = UIColor.clear
        self.addSubview(stateLabel)
    }
    
    // MARK: - ********* 在这里设置子控件的位置和尺寸
    override func placeSubviews() {
        super.placeSubviews()
        stateLabel.frame = self.bounds
        loading.center = CGPoint.init(x: self.mj_w * 0.5, y: self.mj_h * 0.5)
    }
    
    override var state: MJRefreshState {
        get {
            return super.state
        }
        set(newState) {
            if newState == state {
                return
            }
            super.state = newState
            loading.hidesWhenStopped = false
            switch state {
            case .idle:
                loading.stopAnimating()
            case .pulling:
                loading.stopAnimating()
            case .refreshing:
                loading.startAnimating()
            case .noMoreData:
                loading.hidesWhenStopped = true
                loading.stopAnimating()
            default:
                break
            }
            stateLabel.text = stateTitles[newState] ?? ""
        }
    }
}
