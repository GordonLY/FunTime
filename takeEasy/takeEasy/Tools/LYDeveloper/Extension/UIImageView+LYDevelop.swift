//
//  UIImageView+LYDevelop.swift
//  takeEasy
//
//  Created by Gordon on 2017/12/27.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit
import Kingfisher

extension LYDevelop where Base: UIImageView {
    func addCorner(_ radius: CGFloat) {
        if radius == 0 { return }
        base.image = base.image?.ly.drawRectWithRoundedCorner(radius: radius, base.bounds.size)
    }
    func addCorner(_ radius: CGFloat, image: UIImage?) {
        if radius == 0 {
            base.image = image
            return
        }
        base.image = image?.ly.drawRectWithRoundedCorner(radius: radius, base.bounds.size)
    }
    
    public func setImage(with imgUrl: URL?,
                         cornerRadius: CGFloat = 0,
                         placeholder: Placeholder? = nil,
                         options: KingfisherOptionsInfo? = nil,
                         progressBlock: DownloadProgressBlock? = nil,
                         completionHandler: CompletionHandler? = nil)
    {
        guard let resource = imgUrl else {
            placeholder?.add(to: base)
            return
        }
        KingfisherManager.shared.retrieveImage(with: resource, options: options, progressBlock: progressBlock) { [weak base](image, error, cacheType, url) in
            guard let sBase = base else { return }
            let size = sBase.bounds.size
            DispatchQueue.global().async {
                let img = image?.ly.drawRectWithRoundedCorner(radius: cornerRadius, size)
                DispatchQueue.main.async {
                    sBase.image = img
                }
            }
            completionHandler?(image, error, cacheType, url)
        }
    }
}
