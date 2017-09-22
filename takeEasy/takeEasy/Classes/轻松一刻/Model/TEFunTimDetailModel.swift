//
//  TEFunTimDetailModel.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/3.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit

@objcMembers
class TEFunTimDetailModel: NSObject {

    /// 音频地址
    var url_m3u8 = "" {
        didSet {
            guard let url = URL.init(string: url_m3u8) else { return }
            let fileName = url.lastPathComponent
            let directory = FileManager.ly_funTimeDirectory()
            let filePath =  (directory as NSString).appendingPathComponent(fileName)
            if FileManager.ly_fileExists(atPath: filePath) {
                mp3Url = URL.init(fileURLWithPath: filePath)
                isDownload = true
            }
            else {
                mp3Url = URL.init(string: url_m3u8)
            }
        }
    }
    
    var isDownload = false
    
    /// mp3 url
    var mp3Url: URL?
    /// 音频title
    var alt = ""
    /// source
    var videosource = ""
    /// 音频cover
    var cover = ""
}
