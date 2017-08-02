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
    func lyNetworkReponseSucceed(urlStr:String, result: Dictionary<String, Any>?)
    ///  请求参数错误
    func lyNetworkReponseIncorrectParam(urlStr:String, message: String?)
    ///  请求失败
    func lyNetworkReponseFailed(urlStr:String, error: Error?)
}

class LYRequestManager: NSObject {
    
    var requestsArr = [DataRequest]()
    
    weak var delegate : LYRequestManagerDelegate?
    
    deinit {
        requestsArr.forEach {$0.cancel()}
    }
    // MARK: - ********* 代理回调
    func p_callDelegate(success urlStr:String, data:Dictionary<String, Any>?) {
        delegate?.lyNetworkReponseSucceed(urlStr: urlStr, result: data)
    }
    func p_callDelegate(incorrect urlStr:String, msg:String?) {
        delegate?.lyNetworkReponseIncorrectParam(urlStr: urlStr, message: msg)
    }
    func p_callDelegate(fail urlStr:String, error:Error?) {
        delegate?.lyNetworkReponseFailed(urlStr: urlStr, error: error)
    }
    
    func lyLoaclCache(urlStr:String, param:Dictionary<String, Any>?) -> Dictionary<String, Any>? {
        return LYNetWorkRequest.loadCacheDataBy(urlStr: urlStr, dict: param)
    }
    // MARK: - ********* 网络请求
    // MARK: >>> get post Request
    func lyRequest(urlStr:String, param:Dictionary<String, Any>?) {
        var methodType: HTTPMethod = .post
        if net_getMethods.contains(urlStr) {
            methodType = .get
        }
        self.p_request(type: methodType, urlStr: urlStr, param: param)
    }
    func lyGetRequset(urlStr:String, param:Dictionary<String, Any>?) {
        self.p_request(type: .get, urlStr: urlStr, param: param)
    }
    func lyPostRequset(urlStr:String, param:Dictionary<String, Any>?) {
        self.p_request(type: .post, urlStr: urlStr, param: param)
    }
    private func p_request(type:HTTPMethod, urlStr:String, param:Dictionary<String, Any>?) {
        var needCache = false
        if net_needCache.contains(urlStr) {
            needCache = true
        }
        requestsArr.append(LYNetWorkRequest.baseRequest(httpMethod: type, urlStr: urlStr, dict: param, isCache: needCache, needToken: true, success: { [weak self](response) in
            self?.p_callDelegate(success: urlStr, data: response)
            }, notSuccess: { [weak self](message) in
                self?.p_callDelegate(incorrect: urlStr, msg: message)
        }) { [weak self](error) in
            self?.p_callDelegate(fail: urlStr, error: error)
        })
    }
    // MARK: >>> upload file
    func lyUpload(imgData:Data, urlStr:String) {
        LYNetWorkRequest.uploadPhoto(imgData: imgData, urlStr: urlStr, success: { [weak self](response) in
            self?.p_callDelegate(success: urlStr, data: response)
        }) { [weak self](error) in
            self?.p_callDelegate(fail: urlStr, error: error)
        }
    }
    
    // MARK: >>> request with block
    ///  request with block call back
    func lyRequest(urlStr:String, param:Dictionary<String, Any>?, success:((Dictionary<String, Any>?) -> Void)?, incorrect:((String?) -> Void)?, fail:((Error?) -> Void)?) {
        var methodType: HTTPMethod = .post
        if net_getMethods.contains(urlStr) {
            methodType = .get
        }
        self.p_lyRequest(type: methodType, urlStr: urlStr, param: param, success: success, incorrect: incorrect, fail: fail)
    }
    ///  get request with block call back
    func lyGetRequest(urlStr:String, param:Dictionary<String, Any>?, success:((Dictionary<String, Any>?) -> Void)?, incorrect:((String?) -> Void)?, fail:((Error?) -> Void)?) {
        self.p_lyRequest(type: .get, urlStr: urlStr, param: param, success: success, incorrect: incorrect, fail: fail)
    }
    ///  post request with block call back
    func lyPostRequest(urlStr:String, param:Dictionary<String, Any>?, success:((Dictionary<String, Any>?) -> Void)?, incorrect:((String?) -> Void)?, fail:((Error?) -> Void)?) {
        self.p_lyRequest(type: .post, urlStr: urlStr, param: param, success: success, incorrect: incorrect, fail: fail)
    }
    ///  get request with block call back
    private func p_lyRequest(type:HTTPMethod, urlStr:String, param:Dictionary<String, Any>?, success:((Dictionary<String, Any>?) -> Void)?, incorrect:((String?) -> Void)?, fail:((Error?) -> Void)?) {
        var needCache = false
        if net_needCache.contains(urlStr) {
            needCache = true
        }
        requestsArr.append(LYNetWorkRequest.baseRequest(httpMethod: type, urlStr: urlStr, dict: param, isCache: needCache, needToken: true, success: { (response) in
            if success != nil {
                success!(response)
            }
        }, notSuccess: { (message) in
            if incorrect != nil {
                incorrect!(message)
            }
        }) { (error) in
            if fail != nil {
                fail!(error)
            }
        })
    }
    
}
