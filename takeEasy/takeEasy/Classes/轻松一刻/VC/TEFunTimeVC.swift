//
//  TEFunTimeVC.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/3.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit

class TEFunTimeVC: LYBaseViewC {

    // MARK: view cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = kBgColorF5()
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
    override func lyNetworkReponseSucceed(urlStr: String, result:
        Dictionary<String, Any>?) {
    }
    override func lyNetworkReponseIncorrectParam(urlStr: String, code: Int, message: String?) {
        
    }
    // MARK: === 网络请求
    func p_startNetWorkRequest() {
        
    }
    // MARK: - ********* Private Method
    func p_setUpNav() {
        self.navigationItem.title = "Fun Time"
    }

    func p_initSubviews() {
        
    }

}
