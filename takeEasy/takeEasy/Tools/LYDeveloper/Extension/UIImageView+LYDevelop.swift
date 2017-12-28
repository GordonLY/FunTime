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
    
    @discardableResult
    public func setImage(with resource: Resource?,
                         cornerRadius: CGFloat = 0,
                         placeholder: Placeholder? = nil,
                         options: KingfisherOptionsInfo? = nil,
                         progressBlock: DownloadProgressBlock? = nil,
                         completionHandler: CompletionHandler? = nil) -> RetrieveImageTask
    {
        guard let resource = resource else {
            self.placeholder = placeholder
            setWebURL(nil)
            completionHandler?(nil, nil, .none, nil)
            return .empty
        }
        
        let options = KingfisherManager.shared.defaultOptions + (options ?? [KingfisherOptionsInfoItem]())
        let noImageOrPlaceholderSet = base.image == nil && self.placeholder == nil
        
        if !options.keepCurrentImageWhileLoading || noImageOrPlaceholderSet {
            self.placeholder = placeholder
        }
        setWebURL(resource.downloadURL)
        let task = KingfisherManager.shared.retrieveImage(
            with: resource,
            options: options,
            progressBlock: { receivedSize, totalSize in
                guard resource.downloadURL == self.webURL else {
                    return
                }
                if let progressBlock = progressBlock {
                    progressBlock(receivedSize, totalSize)
                }
        },
            completionHandler: {[weak base] image, error, cacheType, imageURL in
                DispatchQueue.main.async {
                    guard let strongBase = base, imageURL == self.webURL else {
                        completionHandler?(image, error, cacheType, imageURL)
                        return
                    }
                    self.setImageTask(nil)
                    guard let image = image else {
                        completionHandler?(nil, error, cacheType, imageURL)
                        return
                    }
                    self.placeholder = nil
                    let size = strongBase.bounds.size
                    DispatchQueue.global().async {
                        let img = image.ly.drawRectWithRoundedCorner(radius: cornerRadius, size)
                        DispatchQueue.main.async {
                            strongBase.image = img
                            completionHandler?(image, error, cacheType, imageURL)
                        }
                    }
                }
        })
        setImageTask(task)
        return task
    }
    
    public func cancelDownloadTask() {
        imageTask?.cancel()
    }
}

// MARK: - Associated Object
private var lastURLKey: Void?
private var placeholderKey: Void?
private var imageTaskKey: Void?

extension LYDevelop where Base: ImageView {
    /// Get the image URL binded to this image view.
    public var webURL: URL? {
        return objc_getAssociatedObject(base, &lastURLKey) as? URL
    }
    
    fileprivate func setWebURL(_ url: URL?) {
        objc_setAssociatedObject(base, &lastURLKey, url, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate var imageTask: RetrieveImageTask? {
        return objc_getAssociatedObject(base, &imageTaskKey) as? RetrieveImageTask
    }
    
    fileprivate func setImageTask(_ task: RetrieveImageTask?) {
        objc_setAssociatedObject(base, &imageTaskKey, task, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    public fileprivate(set) var placeholder: Placeholder? {
        get {
            return (objc_getAssociatedObject(base, &placeholderKey) as? Boxx<Placeholder?>)?.value
        }
        
        set {
            if let previousPlaceholder = placeholder {
                previousPlaceholder.remove(from: base)
            }
            
            if let newPlaceholder = newValue {
                newPlaceholder.add(to: base)
            } else {
                base.image = nil
            }
            
            objc_setAssociatedObject(base, &placeholderKey, Boxx(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}


private class Boxx<T> {
    let value: T
    init(value: T) {
        self.value = value
    }
}
