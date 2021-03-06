//
//  TEFunTimeDetailVC.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/3.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit
import Hero

class TEFunTimeDetailVC: LYBaseViewC {

    init(_ callBack: @escaping () -> Void) {
        self.callBack = callBack
        super.init(nibName: nil, bundle: nil)
    }
    var callBack: () -> Void
    var funTimeData = TETimeListData()
    private var detailModel = TEFunTimDetailModel()
    private var playView: TEFunTimePlayerView!
    // MARK: view cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.isHeroEnabled = true
        self.p_setUpNav()
        self.p_initSubviews()
        self.p_startNetWorkRequest()
    }
    override func viewDidDisappear(_ animated: Bool) {
        callBack()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

        let navSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: self, action: #selector(p_actionLeft))
        let left = UIButton.init(type: .custom)
        left.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44)
        left.setImage(UIImage.init(named: "common_back"), for: .normal)
        left.setImage(UIImage.init(named: "common_back")?.ly_image(tintColor: UIColor.init(white: 0, alpha: 0.5)), for: .highlighted)
        left.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        left.addTarget(self, action: #selector(p_actionLeft), for: .touchUpInside)
        let leftItem = UIBarButtonItem.init(customView: left)
        self.navigationItem.leftBarButtonItems = [navSpacer,leftItem]
    }
    @objc func p_actionLeft() {
        self.navigationController?.popViewController(animated: true)
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
        title.heroID = "funTimeListCell_title"
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
        playView.heroID = "funTimeListCell_imgView"
        self.view.addSubview(playView)
        
    }
}
