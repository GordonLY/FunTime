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
    /// 测试环境
    case test
    /// 预发布环境
    case preOnline
    /// 线上环境
    case online
}
private let developConfig: DevelopEnvironment = .online


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
        return "http://10.195.16.19:5088/appapi/" + str
    case .test:
        return "http://10.195.16.19:5088/appapi/" + str
    case .preOnline:
        return "http://preapp.kmbear.com/appapi/" + str
    case .online:
        return "http://app.kmbear.com/appapi/" + str
    }
}

///  图片url 前缀
func kGetImgUrl(_ str:String) -> String {
    switch developConfig {
    case .debug:
        return "http://10.195.16.7/" + str
    case .test:
        return "http://10.195.16.7/" + str
    case .preOnline:
        return "http://preimage.kmbear.com/" + str
    case .online:
        return "http://image.kmbear.com/" + str
    }
}

///  图片Url 合成
func kImgUrl(_ str:String) -> URL {
    var urlStr = ""
    switch developConfig {
    case .debug:
        urlStr = "http://10.195.16.7/" + str
    case .test:
        urlStr = "http://10.195.16.7/" + str
    case .preOnline:
        urlStr = "http://preimage.kmbear.com/" + str
    case .online:
        urlStr = "http://image.kmbear.com/" + str
    }
    return URL.init(string: urlStr) ?? URL.init(string: "image.kmbear.com/")!
}

///  上传头像服务器
func kImgServeUrl() -> String {
    switch developConfig {
    case .debug:
        return "http://10.195.16.19:8082/img/uploadFile/"
    case .test:
        return "http://10.195.16.19:8082/img/uploadFile/"
    case .preOnline:
        return "http://preupload.kmbear.com/img/uploadFile/"
    case .online:
        return "http://upload.kmbear.com/img/uploadFile/"
    }
}

// h5 页面地址
func kH5ServeUrl(_ str:String) -> String {
    let today = p_getCurrentDay()
    switch developConfig {
    case .debug:
        return "http://10.195.13.132:8080/src/weex.html?" + today + "#/" + str
    case .test:
        return "http://10.195.16.24/src/weex.html?" + today + "#/" + str
    case .preOnline:
        return "http://preh5.kmbear.com/src/weex.html?" + today + "#/" + str
    case .online:
        return "http://h5.kmbear.com/src/weex.html?" + today + "#/" + str
    }
}

private var currentDay = ""
private func p_getCurrentDay() -> String {
    guard currentDay == ""  else {
        return currentDay
    }
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd"
    let dateStr = formatter.string(from: date)
    currentDay = dateStr
    return currentDay
}

/// 请求方式是get的集合
let net_getMethods: Set = [kNet_bannerData,kNet_infomation,kNet_gencode,
                       kNet_userinfo,kNet_babyList,kNet_tokenValidate,
                       kNet_needEvalution,kNet_advertise]

/// 需要缓存数据的集合
let net_needCache: Set = [kNet_bannerData,kNet_infomation,kNet_userinfo,
    kNet_historyActList,kNet_recommendActsUrl,kNet_activityUrl,
    kNet_advertise]

/// 首页banner
let kNet_bannerData      = kApiUrl("carousels")
/// 首页 资讯
let kNet_infomation     = kApiUrl("informations")
/// 首页 广告
let kNet_advertise      = kApiUrl("V1.3/selectAdvertises")
/// token是否过期
let kNet_tokenValidate  = kApiUrl("tokenStatus")
/// baby是否需要测评
let kNet_needEvalution  = kApiUrl("V1.3/getStatus")
/// 活动列表
let kNet_activityUrl    = kApiUrl("activitys/getByPage")
/// 推荐活动列表
let kNet_recommendActsUrl = kApiUrl("recommendActivitys/getByPage")
/// 获取验证码
let kNet_gencode        = kApiUrl("getSms")
/// 用户注册
let kNet_register       = kApiUrl("V1.4/register")
/// 用户登录
let kNet_login          = kApiUrl("V1.4/login")
/// 退出登录
let kNet_logout         = kApiUrl("logout")
/// 用户信息
let kNet_userinfo       = kApiUrl("userinfo")
/// 重新设置密码
let kNet_resetPassword  = kApiUrl("V1.4/changePassword")
/// 修改用户信息
let kNet_editUserInfo   = kApiUrl("user/updateContent")
/// 添加联系人
let kNet_addContact     = kApiUrl("user/topContacts")
/// 编辑联系人
let kNet_editContact    = kApiUrl("user/topContacts")
/// 联系人列表
let kNet_contactList    = kApiUrl("user/topContacts/getByPage")
/// 删除联系人
let kNet_deleteContact  = kApiUrl("user/topContacts/delete")
/// 我的订单列表
let kNet_orderList      = kApiUrl("userActivity/getByOrderStatus")
/// 我的订单详情
let kNet_orderDetail    = kApiUrl("userActivity/getOrderDetail")
/// 取消订单
let kNet_cancelOrder    = kApiUrl("userActivity/cancelMyActivity")
/// 删除订单
let kNet_deleteOrder    = kApiUrl("userActivity/deleteMyActivity")
/// 历史活动活动列表
let kNet_historyActList = kApiUrl("getHitoryActs")
/// 我的宝宝列表
let kNet_babyList       = kApiUrl("findAllBaby")
/// 添加宝宝
let kNet_addBaby        = kApiUrl("users/userBabys")
/// 编辑宝宝
let kNet_editBaby       = kApiUrl("users/userBabys")
/// 删除宝宝
let kNet_deleteBaby     = kApiUrl("deleteBaby")
/// 意见反馈
let kNet_opinion        = kApiUrl("feedback")
/// 报名下单
let kNet_joinAct        = kApiUrl("order/sign_up")
/// 微信下单
let kNet_wechatPay      = kApiUrl("wxPay/payOrder")
/// 用户签到
let kNet_actSign        = kApiUrl("userActivity/sign")
/// 任务列表查询
let kNet_taskList       = kApiUrl("selectMyALLTask")
/// 任务内容查询
let kNet_taskContent    = kApiUrl("selectMyActivityTask")
/// 完成任务
let kNet_taskComplete   = kApiUrl("updateActivityTaskStatistic")

// MARK: >>> V1.4
/// 未读消息统计
let kNet_newNotiCount    = kApiUrl("newNotiCount")
/// 消息列表
let kNet_notiList        = kApiUrl("message/getPageMessage")
/// 读消息
let kNet_readNoti        = kApiUrl("message/editStatus")
/// 删除消息
let kNet_deleNoti        = kApiUrl("message/delete")
/// 收藏列表
let kNet_myCollect       = kApiUrl("collection")
/// 收藏 老师 机构 活动
let kNet_toCollect       = kApiUrl("toCollection")
/// 查询我的评价
let kNet_getAllMyComment = kApiUrl("getAllMyComment")
/// 查询评价待选tags
let kNet_commentTags     = kApiUrl("selectCommentTag")
/// 评价统计（活动 or 机构）
let kNet_commentSum      = kApiUrl("getCommentTagNumber")
/// 评价活动
let kNet_assessMyAct     = kApiUrl("toAssessMyAct")
/// 老师详情
let kNet_teacherDetail   = kApiUrl("getTeacherById?")
/// 机构详情
let kNet_organDetail     = kApiUrl("getBusinessById?")
/// 在线活动列表（活动 or 机构）
let kNet_onlineActList   = kApiUrl("getOnlineActPage")
/// 历史活动列表（活动 or 机构）
let kNet_offlineActList  = kApiUrl("getHisActPage")
