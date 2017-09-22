//
//  TEFunTimeVC.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/3.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit


class TEFunTimeVC: LYBaseViewC, UITableViewDelegate, UITableViewDataSource {

    private var tableView: UITableView!
    private var cellModels = [TEFunTimeListModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    // MARK: view cycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    // MARK: - ********* UITableView delegate and dataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kFitCeilWid(90)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TEFunTimeCell.cellWithTableView(tableView, indexPath: indexPath)
        cell.model = cellModels[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detail = TEFunTimeDetailVC()
        detail.funTimeModel = cellModels[indexPath.row]
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    // MARK: - ********* 网络数据
    // MARK: === 网络响应
    override func ly_netReponseSuccess(urlStr: String, result: Dictionary<String, Any>?) {
        if let data = result?["S1426236711448"] as? [String: Any],
            let topics = data["topics"] as? [[String: Any]],
            let first = topics.first,
            let docs = first["docs"] as? [[String: Any]],
            let models = TEFunTimeListModel.ly_objArray(with: docs) as? [TEFunTimeListModel]
        {
            cellModels = models
        }
    }
    override func ly_netReponseIncorrect(urlStr: String, code: Int, message: String?) {
        d_print("==== incorrect : \(message ?? "")")
    }

    // MARK: === 网络请求
    func p_startNetWorkRequest() {
        
        if let cacheDic = netMng.ly_LoaclCache(urlStr: kNet_funtimeList, param: nil),
            let needRefresh = cacheDic["needRefresh"] as? Bool
        {
            self.ly_netReponseSuccess(urlStr: kNet_funtimeList, result: cacheDic)
            if needRefresh {
                netMng.ly_getRequset(urlStr: kNet_funtimeList, param: nil)
            }
        } else {
            netMng.ly_getRequset(urlStr: kNet_funtimeList, param: nil)
        }
    }
    // MARK: - ********* Private Method
    func p_setUpNav() {
        self.navigationItem.title = "Fun Time"
    }

    func p_initSubviews() {
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
