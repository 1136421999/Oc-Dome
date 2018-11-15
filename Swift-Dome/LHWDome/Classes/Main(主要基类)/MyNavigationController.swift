//
//  MyNavigationController.swift
//  HQWG
//
//  Created by Hanwen on 2018/3/16.
//  Copyright © 2018年 SK丿希望. All rights reserved.
//

import UIKit
//import SwifterSwift

class MyNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setStatusBarStyle()
    }
    
    //MARK: 重写跳转
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        /// 重新定义push之后的Controller
        
        if self.viewControllers.count>0 {
            UIView.animate(withDuration: 0.5, animations: {
                viewController.hidesBottomBarWhenPushed = true
            })
            
        }
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        viewController.navigationItem.backBarButtonItem = item
        super.pushViewController(viewController, animated: animated)
    }
}
extension MyNavigationController {
    func setNavigationBar() {
        let  navigationBar = UINavigationBar.appearance()
        // 设置导航栏背景颜色
        
//        navigationBar.setBackgroundImage(UIImage(color: HWNavigationBarColor(), size: CGSize(width: HWScreenW(), height: HWScreenH())), for: UIBarMetrics.default)
        navigationBar.setBackgroundImage(UIColor.black.hw_toImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        //标题颜色
        navigationBar.titleTextAttributes =  [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18)]
        navigationBar.tintColor = UIColor.white //item 字体颜色
    }
    
    
    func setStatusBarStyle() {
        //         第一步：在Info.plist中设置UIViewControllerBasedStatusBarAppearance 为NO
        //         第二步：在viewDidLoad中加一句
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent // 修改状态栏颜色
//         UIApplication.shared.statusBarStyle = UIStatusBarStyle.default // 修改状态栏颜色
        //        这样就可以把默认的黑色改为白色。
        //        第二种：只是部分控制器需要修改状态栏文字的颜色：
        //        可以重写以下方法即可！
        //        override func preferredStatusBarStyle() -> UIStatusBarStyle {
        //            return UIStatusBarStyle.LightContent;
        //        }
    }
}

