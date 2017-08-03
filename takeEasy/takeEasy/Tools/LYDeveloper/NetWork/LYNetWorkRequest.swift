//
//  LYNetWorkRequest.swift
//  kemiBear
//
//  Created by 李扬 on 2017/4/20.
//  Copyright © 2017年 李扬. All rights reserved.
//

import UIKit
import Alamofire

enum LYError: Error {
    
    case netError(String?)
    
    func ly_errorInfo() -> String {
        switch self {
        case .netError(let info):
            if let info = info {
                return info
            }
            return ""
        }
    }
}

class LYNetWorkRequest: NSObject {

    // MARK: - ********* Public Method
    // MARK: === 获取本地缓存的数据
    class func ly_loadCacheDataWith(urlStr:String, dict:Dictionary<String, Any>?) -> Dictionary<String, Any>? {
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
    // MARK: === get request
    class func ly_getRequest(urlStr:String, dict:Dictionary<String, Any>?, isCache:Bool, success:((Dictionary<String, Any>) -> Void)?, notSuccess:((Int, String) -> Void)?, failure:((LYError?) -> Void)?) -> DataRequest {
        
        return self.ly_baseRequest(httpMethod: .get, urlStr: urlStr, dict: dict, isCache: isCache, success: success, notSuccess: notSuccess, failure: failure)
    }
    // MARK: === post request
    class func ly_postReques(urlStr:String, dict:Dictionary<String, Any>?, isCache:Bool, success:((Dictionary<String, Any>) -> Void)?, notSuccess:((Int, String) -> Void)?, failure:((LYError?) -> Void)?) -> DataRequest {
        
        return self.ly_baseRequest(httpMethod: .post, urlStr: urlStr, dict: dict, isCache: isCache, success: success, notSuccess: notSuccess, failure: failure)
    }
    // MARK: === base request
    class func ly_baseRequest(httpMethod:HTTPMethod, urlStr:String, dict:Dictionary<String, Any>?, isCache:Bool, success:((Dictionary<String, Any>) -> Void)?, notSuccess:((Int, String) -> Void)?, failure:((LYError?) -> Void)?) -> DataRequest {
        // 缓存设置
        var fileCachePath: String? = nil
        if isCache {
            fileCachePath = self.p_getCachePathBy(urlStr: urlStr, dict: dict)
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
            if let success = success, response.result.isSuccess,
                let result = response.result.value as? Dictionary<String, Any>,
                  result.keys.contains("S1426236711448") {
                // success
                // 缓存 (只缓存成功的数据)
                if fileCachePath != nil {
                    (result as NSDictionary).write(toFile: fileCachePath!, atomically: true)
                }
                success(result)
            } else {
                // failure
                if let failure = failure,
                    let error = response.result.error {
                    failure(LYError.netError(error.localizedDescription))
                }
            }
        }
    }
    
    // MARK: === 上传图片
    class func ly_uploadPhoto(imgData:Data, urlStr:String, success:((Dictionary<String, Any>) -> Void)?, failure:((LYError?) -> Void)?) {
        
        Alamofire.upload(multipartFormData: { (formData) in
            formData.append(imgData, withName: "file", fileName: "kemiBear.png", mimeType: "application/octet-stream")
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: "", method: .post, headers: nil, encodingCompletion: { (encodingResult) in
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
                    failure(LYError.netError(encodingError.localizedDescription))
                }
            }
        })
    }
    // MARK: === 下载文件
    class func ly_downloadFile(atPath path: String, progress: ((Progress, String) -> Void)?, success: ((URL?) -> Void)?) -> DownloadRequest? {
        
        // 1.视频地址
        guard let url = URL.init(string: path) else { return nil }
        let fileName = url.lastPathComponent
        // 2.视频缓存位置
        let cachePath = self.p_getFileCachePath()
        let v_filePath = (cachePath as NSString).appendingPathComponent(fileName)
        let v_fileUrl = URL.init(string: v_filePath)!
        let v_cachePath = (cachePath as NSString).appendingPathComponent("\(fileName)cache")
        let destination: DownloadRequest.DownloadFileDestination = { _, response in
            return (v_fileUrl, [.removePreviousFile, .createIntermediateDirectories])
        }
        // 3.分情况处理请求
        // 3.1 已下载完成
        if FileManager.ly_fileExists(atPath: v_filePath) {
            if let success = success {
                success(URL.init(string: v_filePath))
            }
            return nil
        }
        // 3.2 已下载但未完成，有resumeData
        if FileManager.ly_fileExists(atPath: v_cachePath),
            let v_cacheUrl = URL.init(string: v_cachePath),
              let resumeData = try? Data.init(contentsOf: v_cacheUrl) {
            return Alamofire.download(resumingWith: resumeData, to: destination)
                .downloadProgress(closure: {(downProgress) in
                    if let progress = progress {
                        progress(downProgress,fileName)
                    }
                })
                .response { (response) in
                    _ = FileManager.ly_removeItem(atPath: v_cachePath)
                    if let success = success {
                        success(response.destinationURL)
                    }
                }
        }
        // 3.3 未下载
        return Alamofire.download(url, to: destination)
            .downloadProgress(closure: {(downProgress) in
                if let progress = progress {
                    progress(downProgress,fileName)
                }
            })
            .response { (response) in
                if let success = success {
                    success(response.destinationURL)
                }
            }
    }
    
    // MARK: === 取消当前文件下载
    class func ly_cancelCurrent(downloadTask: DownloadRequest?) {
        
        guard let task = downloadTask,
                let requestUrl = task.request?.url else {
            return
        }
        let fileName = requestUrl.lastPathComponent
        let cachePath = self.p_getFileCachePath()
        let v_cachePath = (cachePath as NSString).appendingPathComponent("\(fileName)cache")
        let cacheUrl = URL.init(string: v_cachePath)!
        do {
            try task.resumeData?.write(to: cacheUrl)
        } catch {
            
        }
    }
    
    
    // MARK: - ********* Private Method
    // MARK: === 获取缓存路径
    private class func p_getCachePathBy(urlStr:String, dict:Dictionary<String, Any>?) -> String {
        
        let str = FileManager.ly_libraryCachesPath() as NSString
        let path = str.appendingPathComponent(kNetWorkDataCache)
        if !FileManager.ly_fileExists(atPath: path) {
            _ = FileManager.ly_createDirectories(forPath: path)
        }
        let dict = dict ?? [:]
        let nameStr = urlStr.appending(dict.description)
        let name = nameStr.ly.md5()
        let filePath = (path as NSString).appendingPathComponent(name)
        return filePath
    }
    // MARK: === 文件下载的目录
    private class func p_getFileCachePath() -> String {
        let path = (FileManager.ly_libraryCachesPath() as NSString).appendingPathComponent("takeEasy_fileCaches")
        if FileManager.ly_fileExists(atPath: path) {
            _ = FileManager.ly_createDirectories(forPath: path)
        }
        return path
    }
}

/*
// MARK: === base request
class func ly_baseRequest(httpMethod:HTTPMethod, urlStr:String, dict:Dictionary<String, Any>?, isCache:Bool, success:((Dictionary<String, Any>) -> Void)?, notSuccess:((Int, String) -> Void)?, failure:((LYError?) -> Void)?) -> DataRequest {
    // 缓存设置
    var fileCachePath: String? = nil
    if isCache {
        fileCachePath = self.p_getCachePathBy(urlStr: urlStr, dict: dict)
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
        if let success = success, response.result.isSuccess,
            let result = response.result.value as? Dictionary<String, Any>,
            result.keys.contains("code") {
            // success
            // 缓存 (只缓存成功的数据)
            if let code = result["code"] as? Int, code == 0 {
                if fileCachePath != nil {
                    (result as NSDictionary).write(toFile: fileCachePath!, atomically: true)
                }
                success(result)
            } else {
                 //  code != 0 ，not success
                 if let notSuccess = notSuccess, let msg = result["mes"] as? String, let code = result["code"] as? Int {
                    notSuccess(code,msg)
                 }
            }
        } else {
            // failure
            if let failure = failure,
                let error = response.result.error {
                failure(LYError.netError(error.localizedDescription))
            }
        }
    }
}
*/
