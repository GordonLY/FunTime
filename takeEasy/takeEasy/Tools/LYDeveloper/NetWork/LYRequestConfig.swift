//
//  LYRequestConfig.swift
//  kemiBear
//
//  Created by 李扬 on 2017/4/23.
//  Copyright © 2017年 李扬. All rights reserved.
//

import Foundation

///  netWork Config
let kNetWorkDataCache = "NetWorkDataCache"
let kCacheDataSaveTimeLong: TimeInterval = 60 * 60 * 6 // 半天
let kCacheDataSaveTimeShort: TimeInterval = 60 * 30 // 半小时

let kPageSize = 10

// MARK: - ****** 服务器地址相关 ******
private enum DevelopEnvironment {
    /// 调试环境
    case debug
    /// 线上环境
    case online
}
private let developConfig: DevelopEnvironment = .debug


///  print 
func d_print(_ item:  Any?) {
    if developConfig != .online, let item = item {
        print(item)
    }
//    if  let item = item {
//        print(item)
//    }
}

///  url
func kApiUrl(_ str:String) -> String {
    switch developConfig {
    case .debug:
        return "https://c.m.163.com/nc/" + str
    case .online:
        return "https://c.m.163.com/nc/" + str
    }
}

/// 需要缓存数据的集合
let net_needCache: Set = [kNet_funtimeList]

let kNet_funtimeList    =   kApiUrl("special/S1426236711448.html")
let kNet_funtimeDetail  =   kApiUrl("article/preload/")


