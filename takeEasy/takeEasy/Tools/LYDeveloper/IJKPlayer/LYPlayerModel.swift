//
//  LYPlayerModel.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/12.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit

class LYPlayerModel: NSObject {

    var url: URL?
    var cover_img: UIImage?
    var title = "" {
        didSet {
            if title.hasPrefix("轻松一刻语音版:") {
                title.removeSubrange(title.range(of: "轻松一刻语音版:")!)
            }
        }
    }
    var artist = ""
    
}
