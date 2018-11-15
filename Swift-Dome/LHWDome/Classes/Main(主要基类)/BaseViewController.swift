//
//  BaseViewController.swift
//  BBCShop
//
//  Created by 梁琪琛 on 2018/2/9.
//  Copyright © 2018年 SK丿希望. All rights reserved.
//

import UIKit
//import RxSwift

class BaseViewController: UIViewController {
//    let disposeBag = DisposeBag()
    override func viewDidLoad() {
//        switchNavMainColor()
        super.viewDidLoad()
//        setBGColor()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("进入了---\(type(of: self))")
    }
    deinit {
        print("\(type(of: self))释放")
//        self.hw_dismissHUD()
//        HUDManage = nil
        NotificationCenter.default.removeObserver(self)
    }

}

