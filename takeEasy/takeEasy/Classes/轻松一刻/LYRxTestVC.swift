//
//  LYRxTestVC.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/17.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit
import RxSwift


class LYRxTestVC: LYBaseViewC {

    // MARK: view cycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.navigationItem.title = "RXSwift Test"
        
    }

    func p_initSubviews() {
        
        let subject = ReplaySubject<Int>.create(bufferSize: 1)
        
        
        let sub1 = subject.subscribe(
            onNext: { print($0) },
            onDisposed: { print(" sub1 idsposed") }
        )
        subject.onNext(2)
        subject.onNext(3)
        sub1.dispose()
        
        let sub2 = subject.subscribe(
            onNext: { print($0) },
            onCompleted: { print("===== complete") },
            onDisposed: { print(" sub2 idsposed") }
        )
        
        subject.onNext(4)
        subject.onNext(5)
        subject.onCompleted()
        
        sub2.dispose()
    }


}
