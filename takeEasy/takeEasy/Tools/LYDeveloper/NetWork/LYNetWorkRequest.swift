//
//  LYNetWorkRequest.swift
//  kemiBear
//
//  Created by 李扬 on 2017/4/20.
//  Copyright © 2017年 李扬. All rights reserved.
//

import UIKit
import Alamofire

class LYNetWorkRequest: NSObject {

    // MARK: - ********* Public Method
    ///  get request
    class func getRequest(urlStr:String, dict:Dictionary<String, Any>?, isCache:Bool, needToken:Bool, success:((Dictionary<String, Any>) -> Void)?, notSuccess:((String) -> Void)?, failure:((Error?) -> Void)?) -> DataRequest {
        
        return self.baseRequest(httpMethod: .get, urlStr: urlStr, dict: dict, isCache: isCache, needToken: needToken, success: success, notSuccess: notSuccess, failure: failure)
    }
    ///  post request
    class func postReques(urlStr:String, dict:Dictionary<String, Any>?, isCache:Bool, needToken:Bool, success:((Dictionary<String, Any>) -> Void)?, notSuccess:((String) -> Void)?, failure:((Error?) -> Void)?) -> DataRequest {
        
        return self.baseRequest(httpMethod: .post, urlStr: urlStr, dict: dict, isCache: isCache, needToken: needToken, success: success, notSuccess: notSuccess, failure: failure)
    }
    /// base request
    class func baseRequest(httpMethod:HTTPMethod, urlStr:String, dict:Dictionary<String, Any>?, isCache:Bool, needToken:Bool, success:((Dictionary<String, Any>) -> Void)?, notSuccess:((String) -> Void)?, failure:((Error?) -> Void)?) -> DataRequest {
        // 缓存设置
        var fileCachePath: String? = nil
        if isCache {
            if let dic = dict, let pageNum = dic["page"] as? String, Int(pageNum)! > 0  {
                //  pageNum > 0 的数据不缓存
            } else {
                fileCachePath = self.p_getCachePathBy(urlStr: urlStr, dict: dict)
            }
        }
        // 添加token
        let headers: HTTPHeaders = ["token":LYLocalDataMng.shared.token]
        // 打开loading
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        // 打印请求
        d_print(String.init(format: "\n=======================================================\n### 网络请求: \n  <requestUrl> : %@ \n  <paramDict>  : %@ ", urlStr,dict ?? "no request param"))
        // 发送请求
        return Alamofire.request(urlStr, method: httpMethod, parameters: dict, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            // 关闭loading
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            LYToastView.hideLoading()
            // 打印结果
            d_print(String.init(format: "\n=======================================================\n### 响应结果: \n  <responseUrl> : %@ \n  <response>    : %@ ", urlStr,response.result.value as? Dictionary<String, Any> ?? "no response data"))
            if let success = success, response.result.isSuccess,let result = response.result.value as? Dictionary<String, Any>, result.keys.contains("code") {
                // success
                // 缓存 (只缓存成功的数据)
                if let code = result["code"] as? String, (code == "1" || code == "2") {
                    if fileCachePath != nil {
                        (result as NSDictionary).write(toFile: fileCachePath!, atomically: true)
                    }
                    success(result)
                } else {
                    //  code = 0，not success
                    if let notSuccess = notSuccess, let msg = result["mes"] as? String {
                        notSuccess(msg)
                    }
                }
            } else {
                // failure
                if let failure = failure {
                    failure(response.result.error)
                }
            }
        }
    }
    
    ///  upload file
    class func uploadPhoto(imgData:Data, urlStr:String, success:((Dictionary<String, Any>) -> Void)?, failure:((Error?) -> Void)?) {
        
        Alamofire.upload(multipartFormData: { (formData) in
            formData.append(imgData, withName: "file", fileName: "kemiBear.png", mimeType: "application/octet-stream")
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: kImgServeUrl(), method: .post, headers: nil, encodingCompletion: { (encodingResult) in
            LYToastView.hideLoading()
            switch encodingResult {
            case .success(let uploadResult, _, _):
                uploadResult.responseJSON(completionHandler: { (response) in
                    if let success = success,response.result.isSuccess,let result = response.result.value as? Dictionary<String, Any>, let code = result["code"] as? String, code == "1" {
                            success(result)
                    } else {
                        if let failure = failure {
                            failure(nil)
                        }
                    }
                })
            case .failure(let encodingError):
                LYToastView.hideLoading()
                if let failure = failure {
                    failure(encodingError)
                }
            }
        })
    }
    
    ///  获取缓存的数据
    class func loadCacheDataBy(urlStr:String, dict:Dictionary<String, Any>?) -> Dictionary<String, Any>? {
        let filePath = self.p_getCachePathBy(urlStr: urlStr, dict: dict)
        if FileManager.default.fileExists(atPath: filePath),
            var dict = NSMutableDictionary.init(contentsOfFile: filePath) as? Dictionary<String, Any> {
            let cacheDate = FileManager.ly_modifyDateOfItem(atPath: filePath)
            let currentDate = Date()
            dict["needRefresh"] = currentDate.timeIntervalSince(cacheDate) > kCacheDataSaveTimeShort
            return dict
        }
        return nil
    }
    
    // MARK: - ********* Private Method
    ///  获取缓存路径
    private class func p_getCachePathBy(urlStr:String, dict:Dictionary<String, Any>?) -> String {
        
        let str = FileManager.ly_libraryCachesPath() as NSString
        let path = str.appendingPathComponent(kNetWorkDataCache)
        if !FileManager.ly_fileExists(atPath: path) {
            _ = FileManager.ly_createDirectories(forPath: path)
        }
        let dict = dict ?? [:]
        let nameStr = urlStr.appending(dict.description)
        let name = nameStr.md5() 
        let filePath = (path as NSString).appendingPathComponent(name)
        return filePath
    }
}
