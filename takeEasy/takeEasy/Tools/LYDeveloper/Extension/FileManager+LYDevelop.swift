//
//  FileManager+LYDevelop.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/2.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit

extension FileManager {
    
    // MARK: === 获取cachesPath
    class func ly_libraryCachesPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
    }
    // MARK: === 文件是否存在
    class func ly_fileExists(atPath path: String) -> Bool {
        return FileManager.default.fileExists(atPath:path)
    }
    // MARK: === 路径是否是文件夹
    class func ly_isDirectory(atPath path: String) -> Bool {
        var isDir:ObjCBool = false
        FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
        return isDir.boolValue
    }
    // MARK: === 删除文件
    class func ly_removeItem(atPath path: String) ->  Bool {
        if let _ = try? FileManager.default.removeItem(atPath: path) {
            return true
        }
        return false
    }
    // MARK: === 创建文件夹
    class func ly_createDirectories(forPath path: String) ->  Bool {
        guard let _ = try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil) else {
            return false
        }
        return true
    }
    // MARK: === 获取文件修改时间
    class func ly_modifyDateOfItem(atPath path: String) -> Date {
        if let attr = try? FileManager.default.attributesOfItem(atPath: path),
             let modifyDate = attr[.modificationDate] as? Date {
            return modifyDate
        }
        return Date()
    }
    // MARK: === 获取下载文件夹目录
    class func ly_downloadDirectory() -> String {
        let path = (self.ly_libraryCachesPath() as NSString).appendingPathComponent("takeEasy_download")
        if !self.ly_fileExists(atPath: path) {
            _ = FileManager.ly_createDirectories(forPath: path)
        }
        return path
    }
    // MARK: === 轻松一刻下载目录
    class func ly_funTimeDirectory() -> String {
        let path = (self.ly_downloadDirectory() as NSString).appendingPathComponent("网易轻松一刻")
        if !self.ly_fileExists(atPath: path) {
            _ = FileManager.ly_createDirectories(forPath: path)
        }
        return path
    }
    // MARK: === 获取下载文件夹下的 所有目录
    class func ly_subDownloadDirectories() -> [String] {
        let download = self.ly_downloadDirectory()
        guard self.ly_isDirectory(atPath: download),
                let dirArr = try? FileManager.default.contentsOfDirectory(atPath: download) else {
            return []
        }
        var subDownloads = [String]()
        for dir in dirArr {
            let sub = (dir as NSString).appendingPathComponent(dir)
            if self.ly_isDirectory(atPath: sub) {
                subDownloads.append(sub)
            }
        }
        return subDownloads
    }
    // MARK: === 获取文件夹下的所用文件
    class func ly_fileInDirectory(atPath path: String) -> [String] {
        guard self.ly_isDirectory(atPath: path),
            let dirArr = try? FileManager.default.contentsOfDirectory(atPath: path) else {
                return []
        }
        var subFiles = [String]()
        for dir in dirArr {
            let sub = (dir as NSString).appendingPathComponent(dir)
            if !self.ly_isDirectory(atPath: sub) {
                subFiles.append(sub)
            }
        }
        return subFiles
    }
}
