//
//  QRCodeVC.swift
//  takeEasy
//
//  Created by Gordon on 2017/11/29.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit

class QRCodeVC: LBXScanViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.p_setUpNav()
        UIApplication.shared.statusBarStyle = .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func handleCodeResult(arrayResult: [LBXScanResult]) {
        
        let result:LBXScanResult = arrayResult[0]
        let resultStr = result.strScanned ?? ""
        LYAlertView.show(title: resultStr, confirm: "打开链接", cancel: "取消") { [weak self](option) in
            guard let url = URL.init(string: resultStr) else {
                LYToastView.showMessage("URL无效")
                self?.startScan()
                return
            }
            switch option {
            case .confirm:
                UIApplication.shared.openURL(url)
                _ = self?.navigationController?.popViewController(animated: true)
            case .cancel:
                self?.startScan()
            }
        }
    }
}

// MARK: - ********* UIResponse Funcs
extension QRCodeVC {
    fileprivate func p_setUpNav() {
        self.navigationController?.navigationBar.isHidden = true
        let navBg = LYNavBgView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWid(), height: kNavBottom()))
        navBg.titleLabel.text = "扫一扫"
        navBg.titleLabel.textColor = UIColor.white
        navBg.backgroundColor = UIColor.clear
        navBg.line.isHidden = true
        navBg.setLeftViewStyle(.back) {
            _ = self.navigationController?.popViewController(animated: true)
        }
        let img = UIImage.init(named: "common_back")?.ly_image(tintColor: UIColor.white)
        navBg.leftView.setImage(img, for: .normal)
        navBg.leftView.setImage(img?.ly_image(tintColor: UIColor.init(white: 1, alpha: 0.5)), for: .highlighted)
        self.view.addSubview(navBg)
    }
}
