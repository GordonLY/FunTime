//
//  TEFunTimeListModel.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/3.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit


@objcMembers
class TEFunTimeListModel: NSObject {

    /// id
    var postid = ""
    /// 投票数
    var votecount = 0
    /// 发布时间
    var ptime = "" {
        didSet {
            guard let date = Date.init(fromString: ptime, format: .custom("yyyy-MM-dd HH:mm:ss")) else {
                return
            }
            time_show = date.ly_toStringWithRelativeTime()
        }
    }
    var time_show = ""
    /// 来源
    var source = ""
    /// 标题
    var title = ""
    /// url
    var url = ""
    /// 图片地址
    var imgsrc = ""
}
