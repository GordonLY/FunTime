//
//  LYBaseModel.swift
//  takeEasy
//
//  Created by Gordon on 2017/11/30.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit

class LYBaseModel: NSObject, LYRequestManagerDelegate {
    
    lazy var netMng: LYRequestManager = {
        let net = LYRequestManager()
        net.delegate = self
        return net
    }()

    // MARK: - ********* Net Response delegate
    func ly_netReponseSuccess(urlStr: String, result: Dictionary<String, Any>?) {
    }
    func ly_netReponseIncorrect(urlStr: String, code: Int, message: String?) {
    }
    func ly_netReponseFailed(urlStr: String, error: LYError?) {
    }
}



