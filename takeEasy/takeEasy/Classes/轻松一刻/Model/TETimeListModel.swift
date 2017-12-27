//
//  TETimeListModel.swift
//  takeEasy
//
//  Created by Gordon on 2017/11/20.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit

class TETimeListModel: NSObject {
    
    weak var vc: TEFunTimeVC?
    var data = [TETimeListData]()
    private var callBack: (([TETimeListData]) -> Void)?
    lazy var netMng: LYRequestManager = {
        let net = LYRequestManager()
        net.delegate = self
        return net
    }()
}

// MARK: - ********* vc methods
extension TETimeListModel {
    func vc_scanQRCode() {
        let qrCode = QRCodeVC()
        var style = LBXScanViewStyle()
        style.color_NotRecoginitonArea = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.4)
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Inner;
        style.photoframeLineW = 4.0;
        style.photoframeAngleW = 16;
        style.photoframeAngleH = 16;
        style.isNeedShowRetangle = false;
        style.anmiationStyle = LBXScanViewAnimationStyle.NetGrid;
        style.animationImage = UIImage(named: "qrcode_scan_full_net")
        qrCode.scanStyle = style
        vc?.navigationController?.pushViewController(qrCode, animated: true)
    }
}

// MARK: - ********* request and response
extension TETimeListModel: LYRequestManagerDelegate {
    // MARK: === data request
    func getTimeList(_ callBack: @escaping ([TETimeListData]) -> Void) {
        self.callBack = callBack
        if let cacheDic = netMng.ly_LoaclCache(urlStr: kNet_funtimeList, param: nil),
            let needRefresh = cacheDic["needRefresh"] as? Bool {
            ly_netReponseSuccess(urlStr: kNet_funtimeList, result: cacheDic)
            if needRefresh {
                netMng.ly_getRequset(urlStr: kNet_funtimeList, param: nil)
            }
        } else {
            netMng.ly_getRequset(urlStr: kNet_funtimeList, param: nil)
        }
    }
    
    // MARK: === data response
    func ly_netReponseSuccess(urlStr: String, result: Dictionary<String, Any>?) {
        if let _data = result?["S1426236711448"] as? [String: Any],
            let topics = _data["topics"] as? [[String: Any]],
            let first = topics.first,
            let docs = first["docs"] as? [[String: Any]],
            let models = TETimeListData.ly_objArray(with: docs) as? [TETimeListData]
        {
            data = models
            callBack?(data)
        } else {
            callBack?([])
        }
    }
    func ly_netReponseIncorrect(urlStr: String, code: Int, message: String?) {
        
    }
    func ly_netReponseFailed(urlStr: String, error: LYError?) {
        
    }
}

@objcMembers
class TETimeListData: NSObject {
    
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
