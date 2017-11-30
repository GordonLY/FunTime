//
//  TEFunTimeDetailVC.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/3.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit

class TEFunTimeDetailVC: LYBaseViewC {

    var funTimeData = TETimeListData()
    private var detailModel = TEFunTimDetailModel()
    private var playView: TEFunTimePlayerView!
    // MARK: view cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
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
    
    
    // MARK: - ********* 网络数据
    override func ly_netReponseSuccess(urlStr: String, result: Dictionary<String, Any>?) {
        if let data = result?[funTimeData.postid] as? [String: Any],
            let video = data["video"] as? [[String: Any]],
            let first = video.first,
            let model = TEFunTimDetailModel.yy_model(with: first)
        {
            detailModel = model
            playView.detailModel = detailModel
        }
    }
    override func ly_netReponseIncorrect(urlStr: String, code: Int, message: String?) {
        d_print("==== incorrect : \(message ?? "")")
    }
    // MARK: === 网络请求
    func p_startNetWorkRequest() {
        let urlStr = kNet_funtimeDetail + funTimeData.postid + "/full.html"
        netMng.ly_getRequset(urlStr: urlStr, param: nil)
    }
    // MARK: - ********* Private Method
    func p_setUpNav() {
        self.navigationItem.title = "轻松一刻语音版"
    }
    func p_initSubviews() {
        let imgView = UIImageView.init(frame: CGRect.init(x: 0, y: kNavBottom(), width: kScreenWid(), height: kFitWid(64)))
        imgView.backgroundColor = UIColor.white
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage.init(named: "ft_detail_img")
        self.view.addSubview(imgView)
        
        let line = UIView.init(frame: CGRect.init(x: kFitCeilWid(16), y: imgView.height - 0.5, width: imgView.width - kFitCeilWid(32), height: 0.5))
        line.backgroundColor = kSeparateLineColor()
        imgView.addSubview(line)
        
        let title = UILabel.init(frame: CGRect.init(x: kFitCeilWid(16), y: imgView.bottom + kFitCeilWid(20), width: kScreenWid() - kFitCeilWid(32), height: 0))
        title.textColor = UIColor.ly_color(0x111111)
        title.textAlignment = .left
        title.font = kBoldFitFont(size: 22)
        title.numberOfLines = 0
        title.text = funTimeData.title
        title.sizeToFit()
        self.view.addSubview(title)
        
        let subTitle = UILabel.init(frame: CGRect.init(x: kFitCeilWid(16), y: title.bottom + kFitCeilWid(10), width: kScreenWid() - kFitCeilWid(32), height: kFitCeilWid(13)))
        subTitle.font = kRegularFitFont(size: 12)
        subTitle.textColor = kSubTitleColor()
        subTitle.text = funTimeData.source + " " + funTimeData.ptime
        self.view.addSubview(subTitle)
        
        let detail = UILabel.init(frame: CGRect.init(x: subTitle.left, y: subTitle.bottom + kFitCeilWid(30), width: subTitle.width, height: 0))
        detail.textColor = kTitleColor()
        detail.numberOfLines = 0
        detail.font = kRegularFitFont(size: 15)
        detail.text = "轻松一刻语音版，每周二、四、六早上不见不散!"
        detail.sizeToFit()
        self.view.addSubview(detail)
        
        playView = TEFunTimePlayerView.init(frame: CGRect.init(x: 0, y: detail.bottom + kFitCeilWid(20), width: 0, height: 0))
        playView.funTimeData = funTimeData
        self.view.addSubview(playView)
        
    }
    
}
