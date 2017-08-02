//
//  NEHomeViewVC.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/2.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit

class NEHomeViewVC: LYBaseViewC {

    // MARK: view cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = kBgColorF5()
        self.p_setUpNav()
        self.p_initSubviews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    // MARK: - ********* Private Method
    func p_setUpNav() {
        self.navigationItem.title = "Fun Time"
    }
    func p_initSubviews() {
        
    }


}
