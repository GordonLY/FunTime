//
//  TEFunTimeDetailVC.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/3.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit

class TEFunTimeDetailVC: LYBaseViewC {

    // MARK: view cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.p_setUpNav()
        self.p_initSubviews()
        self.p_startNetWorkRequest()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    
    // MARK: - ********* 网络数据
    // MARK: === 网络响应
    override func ly_netReponseSuccess(urlStr: String, result: Dictionary<String, Any>?) {
        
    }
    override func ly_netReponseIncorrect(urlStr: String, code: Int, message: String?) {

    }
    // MARK: === 网络请求
    func p_startNetWorkRequest() {
        
    }
    // MARK: - ********* Private Method
    func p_setUpNav() {
        self.navigationItem.title = "轻松一刻语音版"
        // https://img6.cache.netease.com/utf8/3g-new/img/74c0513beb60b0117ba06f8a64acb3da.png
    }
    func p_initSubviews() {
        
    }

}
