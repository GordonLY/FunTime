//
//  TEFunTimeVC.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/3.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit
import Hero

class TEFunTimeVC: LYBaseViewC {

    private var tableView: UITableView!
    private let model = TETimeListModel()
    // MARK: view cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        model.vc = self
        self.view.backgroundColor = kBgColorF5()
        self.p_setUpNav()
        self.p_initSubviews()
        self.p_startNetWorkRequest()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    // MARK: === 数据请求
    func p_startNetWorkRequest() {
        model.getTimeList { [weak self](dataModel) in
            self?.tableView.reloadData()
        }
    }
}

// MARK: - ********* UIResponse Funcs
extension TEFunTimeVC {
    fileprivate func p_setUpNav() {
        self.navigationItem.title = "Fun Time"
        
        let navSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: self, action: #selector(p_actionLeft))
        let left = UIButton.init(type: .custom)
        left.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44)
        left.setImage(UIImage.init(named: "common_QRCode"), for: .normal)
        left.setImage(UIImage.init(named: "common_QRCode")?.ly_image(tintColor: UIColor.init(white: 0, alpha: 0.5)), for: .highlighted)
        left.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        left.addTarget(self, action: #selector(p_actionLeft), for: .touchUpInside)
        let leftItem = UIBarButtonItem.init(customView: left)
        self.navigationItem.leftBarButtonItems = [navSpacer,leftItem]
    }
    // MARK: === 点击扫描二维码
    @objc fileprivate func p_actionLeft() {
        model.vc_scanQRCode()
    }
}

// MARK: - ********* UITableView delegate and dataSource
extension TEFunTimeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.data.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kFitCeilWid(90)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TEFunTimeCell.cellWithTableView(tableView, indexPath: indexPath)
        cell.data = model.data[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        _ = model.data[1000]
        let cell = tableView.cellForRow(at: indexPath) as? TEFunTimeCell
        cell?.imgView?.heroID = "funTimeListCell_imgView"
        cell?.titleLabel.heroID = "funTimeListCell_title"
        let detail = TEFunTimeDetailVC {
            cell?.imgView?.heroID = nil
            cell?.titleLabel.heroID = nil
        }
        detail.funTimeData = model.data[indexPath.row]
        self.navigationController?.pushViewController(detail, animated: true)
    }
}

// MARK: - ********* UI init
extension TEFunTimeVC {
    
    fileprivate func p_initSubviews() {
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: kNavBottom(), width: kScreenWid(), height: kScreenHei() - kNavBottom()), style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(TEFunTimeCell.self, forCellReuseIdentifier: TEFunTimeCell.CellReuseId)
        self.view.addSubview(tableView)
    }
}
