//
//  MyTabBarController.swift
//  HQWG
//
//  Created by Hanwen on 2018/3/16.
//  Copyright © 2018年 SK丿希望. All rights reserved.
//

import UIKit
//import RxSwift
class MyTabBarController: UITabBarController {
//    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewControllers()
        setUpTabbar()
//        self.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension MyTabBarController {
    //添加所有子控制器
    func addChildViewControllers() {
        setChildrenController(title: "首页", controller: HomeViewController.init())
        setChildrenController(title: "案例", controller: ExampleViewController.init())
        setChildrenController(title: "家族圈", controller: UIViewController.init())
        setChildrenController(title: "我的", controller: MeViewController.init())
    }
    
    //添加一个子控制器
    fileprivate func setChildrenController(title:String,controller:UIViewController) {
        controller.tabBarItem.title = title
        controller.title = title
        controller.navigationItem.title = title
        controller.tabBarItem.image = UIImage(named: "\(title)未选中")
        controller.tabBarItem.selectedImage = UIImage(named: "\(title)选中")
        let naviController = MyNavigationController.init(rootViewController: controller)
        addChildViewController(naviController)
        
    }
    
    
    // MARK: - 设置tabbar
    func setUpTabbar() {
        //根据颜色值画条线
        let rect = CGRect(x:0,y:0,width:UIScreen.main.bounds.width,height:0.5)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.lightGray.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //这两个很主要缺一不可
        tabBar.shadowImage = image
        tabBar.backgroundImage = UIImage()
        
        // MARK: - 设置字体偏移
        UITabBarItem.appearance().titlePositionAdjustment = UIOffsetMake(0.0,0.0)
        // MARK: - tabBar 底部工具栏背景颜色 (以下两个都行)
        // tabBar.barTintColor = UIColor.orange
        // tabBar.backgroundColor = UIColor.white
        
        // MARK: - 设置 tabBar 工具栏字体颜色 (未选中  和  选中)
        // MARK: 修改字体大小
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14)], for: .normal)
        
        // MARK: 修改未选中的颜色
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.lightGray], for: .normal)
        
        
        // MARK: 修改选中的颜色
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.red], for: .selected)
        
        // 设置图片选中时颜色必须设置（系统默认选中蓝色）
        // UITabBar.appearance().tintColor = UIColor.lightGray
        // 或者写法都是一样的
        // self.tabBar.tintColor = UIColor.black
        // self.tabBar.isTranslucent = false  //避免受默认的半透明色影响，关闭
        UITabBar.appearance().backgroundColor=UIColor.white
        
    }
}
//extension MyTabBarController : UITabBarControllerDelegate {
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        if !UserTool.isLogin() {
//            LoginViewController.presentLoginVC(formVC: self) {}
//            return false
//        }
//        if viewController.childViewControllers[0].isKind(of: ComplementaryGoodsViewController.self) {
//            ComplementaryGoodsViewController.presentVC(formVC: self)
//            return false
//        } else  if viewController.childViewControllers[0].isKind(of: ScanningViewController.self) {
//            ScanningViewController.presentVC(formVC: self, type: .into)
//            return false
//        }
//        return true
//    }
//}
