//
//  FileManager+LYDevelop.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/2.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit

extension FileManager {
    
    /// 获取cachesPath
    class func ly_libraryCachesPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
    }
    /// 获取cachesPath URL
    class func ly_libraryCachesURL() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
    /// 文件是否存在
    class func ly_fileExists(atPath path: String) -> Bool {
        return FileManager.default.fileExists(atPath:path)
    }
    /// 删除文件
    class func ly_deleteItem(atPath path: String) ->  Bool {
        if let _ = try? FileManager.default.removeItem(atPath: path) {
            return true
        }
        return false
    }
    /// 创建文件夹
    class func ly_createDirectories(forPath path: String) ->  Bool {
        guard let _ = try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil) else {
            return false
        }
        return true
    }
    /// 获取文件修改时间
    class func ly_modifyDateOfItem(atPath path: String) -> Date {
        if let attr = try? FileManager.default.attributesOfItem(atPath: path),
             let modifyDate = attr[.modificationDate] as? Date {
            return modifyDate
        }
        return Date()
    }
    
}
