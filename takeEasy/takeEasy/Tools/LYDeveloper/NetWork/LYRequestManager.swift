//
//  LYRequestManager.swift
//  kemiBear
//
//  Created by 李扬 on 2017/4/22.
//  Copyright © 2017年 李扬. All rights reserved.
//

import UIKit
import Alamofire

protocol LYRequestManagerDelegate: NSObjectProtocol {
    
    ///  请求成功
    func ly_netReponseSuccess(urlStr:String, result: Dictionary<String, Any>?)
    ///  请求参数错误
    func ly_netReponseIncorrect(urlStr:String, code: Int, message: String?)
    ///  请求失败
    func ly_netReponseFailed(urlStr:String, error: LYError?)
}

class LYRequestManager: NSObject {
    
    var requestsArr = [DataRequest]()
    
    weak var delegate : LYRequestManagerDelegate?
    
    deinit {
        requestsArr.forEach {$0.cancel()}
    }
    // MARK: - ********* 代理回调
    func p_callDelegate(success urlStr:String, data:Dictionary<String, Any>?) {
        delegate?.ly_netReponseSuccess(urlStr: urlStr, result: data)
    }
    func p_callDelegate(incorrect urlStr:String, code: Int, msg:String?) {
        delegate?.ly_netReponseIncorrect(urlStr: urlStr, code: code, message: msg)
    }
    func p_callDelegate(fail urlStr:String, error:LYError?) {
        delegate?.ly_netReponseFailed(urlStr: urlStr, error: error)
    }
    
    // MARK: - ********* 网络请求
    // MARK: === 查找本地缓存数据
    func ly_LoaclCache(urlStr: String, param: Dictionary<String, Any>?) -> Dictionary<String, Any>? {
        return LYNetWorkRequest.ly_loadCacheDataWith(urlStr: urlStr, dict: param)
    }
    // MARK: === 上传文件
    func ly_Upload(imgData:Data, urlStr: String) {
        LYNetWorkRequest.ly_uploadPhoto(imgData: imgData, urlStr: urlStr, success: { [weak self](response) in
            self?.p_callDelegate(success: urlStr, data: response)
        }) { [weak self](error) in
            self?.p_callDelegate(fail: urlStr, error: error)
        }
    }
    // MARK: === 下载文件
    func ly_down(filePath path: String, progress: ((Progress, String) -> Void)?, success: ((URL?) -> Void)?) -> Void {
        _ = LYNetWorkRequest.ly_downloadFile(atPath: path, progress: progress, success: success)
    }
    
    // MARK: === 代理回调方式 请求
    func ly_GetRequset(urlStr:String, param:Dictionary<String, Any>?) {
        self.p_request(type: .get, urlStr: urlStr, param: param)
    }
    func ly_PostRequset(urlStr:String, param:Dictionary<String, Any>?) {
        self.p_request(type: .post, urlStr: urlStr, param: param)
    }
    private func p_request(type:HTTPMethod, urlStr:String, param:Dictionary<String, Any>?) {
        var needCache = false
        if net_needCache.contains(urlStr) {
            needCache = true
        }
        requestsArr.append(LYNetWorkRequest.ly_baseRequest(httpMethod: type, urlStr: urlStr, dict: param, isCache: needCache, success: { [weak self](response) in
            self?.p_callDelegate(success: urlStr, data: response)
            }, notSuccess: { [weak self](code, message) in
                self?.p_callDelegate(incorrect: urlStr, code: code, msg: message)
        }) { [weak self](error) in
            self?.p_callDelegate(fail: urlStr, error: error)
        })
    }
    // MARK: === block回调方式 请求
    func ly_GetRequest(urlStr:String, param:Dictionary<String, Any>?, success:((Dictionary<String, Any>?) -> Void)?, incorrect:((Int,String?) -> Void)?, fail:((Error?) -> Void)?) {
        self.p_lyRequest(type: .get, urlStr: urlStr, param: param, success: success, incorrect: incorrect, fail: fail)
    }
    func ly_PostRequest(urlStr:String, param:Dictionary<String, Any>?, success:((Dictionary<String, Any>?) -> Void)?, incorrect:((Int, String?) -> Void)?, fail:((Error?) -> Void)?) {
        self.p_lyRequest(type: .post, urlStr: urlStr, param: param, success: success, incorrect: incorrect, fail: fail)
    }
    private func p_lyRequest(type:HTTPMethod, urlStr:String, param:Dictionary<String, Any>?, success:((Dictionary<String, Any>?) -> Void)?, incorrect:((Int, String?) -> Void)?, fail:((Error?) -> Void)?) {
        var needCache = false
        if net_needCache.contains(urlStr) {
            needCache = true
        }
        requestsArr.append(LYNetWorkRequest.ly_baseRequest(httpMethod: type, urlStr: urlStr, dict: param, isCache: needCache, success: { (response) in
            if success != nil {
                success!(response)
            }
        }, notSuccess: { (code, message) in
            if incorrect != nil {
                incorrect!(code, message)
            }
        }) { (error) in
            if fail != nil {
                fail!(error)
            }
        })
    }
}
