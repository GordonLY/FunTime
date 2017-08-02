//
//  LYRefreshHeader.swift
//  kemiBear
//
//  Created by 李扬 on 2017/4/19.
//  Copyright © 2017年 李扬. All rights reserved.
//

import UIKit
import MJRefresh

class LYRefreshHeader: MJRefreshHeader {

    private var loading: UIActivityIndicatorView!
    
    override func prepare() {
        super.prepare()
        
        self.mj_h = 55
        
        loading = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        loading.hidesWhenStopped = false
        self.addSubview(loading)
        
    }
    
    // MARK: - ********* 在这里设置子控件的位置和尺寸
    override func placeSubviews() {
        super.placeSubviews()
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
        }
    }
}
