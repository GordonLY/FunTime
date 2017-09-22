//
//  UIViewRefreshExtension.swift
//  kemiBear
//
//  Created by 李扬 on 2017/2/22.
//  Copyright © 2017年 lanrun. All rights reserved.
//

import UIKit

extension LYDevelop where Base: UITableView {
    
    ///  给 tableView 添加 refreshHeader
    func addTableViewHeader(block:@escaping () -> Void) {
        let header = LYRefreshHeader(refreshingBlock: block)
        p_setRefreshHeader(header!)
        base.mj_header = header
    }
    ///  给 tableView 添加 refreshFooter
    func addTableViewFooter(block:@escaping () -> Void) {
        let footer = LYRefreshFooter(refreshingBlock: block)
        p_setRefreshFooter(footer!)
        base.mj_footer = footer
    }
    // MARK: - ********* Private Method
    private func p_setRefreshHeader(_ header:LYRefreshHeader) {
        header.isAutomaticallyChangeAlpha = true
    }
    private func p_setRefreshFooter(_ footer:LYRefreshFooter) {
        footer.setTitle("", for:.noMoreData)
    }
}

extension LYDevelop where Base: UICollectionView {
    
    ///  给 collectionView 添加 refreshHeader
    func addCollectionViewHeader(block:@escaping () -> Void) {
        let header = LYRefreshHeader(refreshingBlock: block)
        p_setRefreshHeader(header!)
        base.mj_header = header
    }
    ///  给 collectionView 添加 refreshFooter
    func addCollectionViewFooter(block:@escaping () -> Void) {
        let footer = LYRefreshFooter(refreshingBlock: block)
        p_setRefreshFooter(footer!)
        base.mj_footer = footer
    }
    // MARK: - ********* Private Method
    private func p_setRefreshHeader(_ header:LYRefreshHeader) {
        header.isAutomaticallyChangeAlpha = true
    }
    private func p_setRefreshFooter(_ footer:LYRefreshFooter) {
        footer.setTitle("", for:.noMoreData)
    }
}


