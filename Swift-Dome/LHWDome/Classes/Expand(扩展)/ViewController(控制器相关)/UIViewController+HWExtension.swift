//
//  UIViewController+HWExtension.swift
//  BBCShop
//
//  Created by Hanwen on 2018/1/15.
//  Copyright © 2018年 SK丿希望. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    // MARK: - 设置相关
    /// 快速设置背景颜色
    func setBGColor(color:UIColor) {
        view.backgroundColor = color
    }
    func setBGColor(_ colorHex:String? = nil) {
        if colorHex == nil {
            view.backgroundColor = HWBGColor()
        } else {
            view.backgroundColor = UIColor.hw_color(hex: colorHex!)
        }
    }
    /// 快速设置title
    func setTitle(title:String) {
        navigationItem.title = title
    }
    /// 快速设置白色titleView
    func setTitleLabel(title:String) {
        weak var weakSelf = self // 弱引用
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 44))
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.white
        label.text = title
        label.textAlignment = .center
        weakSelf?.navigationItem.titleView = label
    }
    
    // MARK: - 跳转相关
    /// 快速push到指定控制器 name:控制器名
    func pushController(name:String) {
        pushSetController(name: name)
    }
    
    @discardableResult
    func pushSetController(name:String) -> UIViewController {
        weak var weakSelf = self // 弱引用
        // 1.获取命名空间
        guard let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] else {
            //            HWPrint("命名空间不存在")
            return UIViewController()
        }
        // 2.通过命名空间和类名转换成类
        let cls : AnyClass? = NSClassFromString((clsName as! String) + "." + name)
        // swift 中通过Class创建一个对象,必须告诉系统Class的类型
        guard let clsType = cls as? UIViewController.Type else {
            //            HWPrint("无法转换成UIViewController")
            return UIViewController()
        }
        // 3.通过Class创建对象
        let vc = clsType.init()
        weakSelf!.navigationController?.pushViewController(vc, animated: true)
        return vc
    }
    
    /// 快速返回指定的控制器 name:要返回的控制器名 (注意:要返回的控制器必须在navigationController的子控制器数组中)
    func popToViewController(name:String) { // 使用 self.popToViewController(name: "JYKMeViewController")
        weak var weakSelf = self // 弱引用
        // 1.获取命名空间
        guard let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] else {
            print("命名空间不存在")
            return
        }
        // 2.通过命名空间和类名转换成类
        let cls : AnyClass? = NSClassFromString((clsName as! String) + "." + name)
        // swift 中通过Class创建一个对象,必须告诉系统Class的类型
        guard (cls as? UIViewController.Type) != nil else {
            print("无法转换成UIViewController")
            return
        }
        for  controller in (weakSelf!.navigationController?.viewControllers)! {
            if controller.isKind(of: cls!) {
                weakSelf!.navigationController?.popToViewController(controller, animated: true)
            }
        }
    }
    /// 快速返回根的控制器
    func popToRootViewController() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func presentController(name:String) {
        presentSetController(name: name, action: {})
    }
    /// 跳转xib并添加导航栏
    @discardableResult
    func presentSetController(name:String, action:@escaping (()->())) -> UIViewController {
        // 1.获取命名空间
        guard let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] else {
            print("命名空间不存在")
            return UIViewController()
        }
        // 2.通过命名空间和类名转换成类
        let cls : AnyClass? = NSClassFromString((clsName as! String) + "." + name)
        // swift 中通过Class创建一个对象,必须告诉系统Class的类型
        guard let clsType = cls as? UIViewController.Type else {
            print("无法转换成UIViewController")
            return UIViewController()
        }
        // 3.通过Class创建对象
        let vc = clsType.init()
        let nav = MyNavigationController(rootViewController: vc)
        UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: {
            action()
        })
        return vc
    }
    
}

// MARK: - 清除导航栏分隔线
extension UIViewController {
    /// 清除导航栏分隔线
    func removeNavigationBarLine() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
    }
    /// 切换渐变导航栏
    func switchGradientColor() {
        navigationController?.navigationBar.setBackgroundImage(HWGradientColor().hw_toImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        navigationController?.navigationBar.titleTextAttributes =  [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white //item 字体颜色
    }
    func switchNavColor(_ color: UIColor) {
        navigationController?.navigationBar.setBackgroundImage(color.hw_toImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        UIApplication.shared.statusBarStyle = color == UIColor.white ? UIStatusBarStyle.default : UIStatusBarStyle.lightContent
        navigationController?.navigationBar.titleTextAttributes =  [NSAttributedStringKey.foregroundColor: color == UIColor.white ? UIColor.black :UIColor.white]
        navigationController?.navigationBar.tintColor = color == UIColor.white ? UIColor.black :UIColor.white //item 字体颜色
    }
    /// 设置导航栏主要颜色
    func switchNavMainColor() {
        navigationController?.navigationBar.setBackgroundImage(HWNavigationBarColor().hw_toImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        navigationController?.navigationBar.titleTextAttributes =  [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white //item 字体颜色
    }
    /// 切换黑色航栏
    func switchBlackColor() {
        navigationController?.navigationBar.setBackgroundImage("24282B".hw_hexColor().hw_toImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        //        navigationController?.navigationBar.barTintColor = "ffffff".hexColor()
        navigationController?.navigationBar.titleTextAttributes =  [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white //item 字体颜色
        navigationController?.navigationBar.isTranslucent = false
    }
    /// 切换白色导航栏
    func switchWhiteColor() {
        navigationController?.navigationBar.setBackgroundImage(UIColor.white.hw_toImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.tintColor = "333333".hw_hexColor()
        //        navigationController?.navigationBar.isTranslucent = false
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        navigationController?.navigationBar.titleTextAttributes =  [NSAttributedStringKey.foregroundColor: "333333".hw_hexColor()]
        navigationController?.navigationBar.tintColor = UIColor.black //item 字体颜色
        navigationController?.navigationBar.isTranslucent = false
    }
    /// 切换透明导航栏
    func switchClearColor() {
        navigationController?.navigationBar.setBackgroundImage(UIColor.clear.hw_toImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        //        navigationController?.navigationBar.isTranslucent = false
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        navigationController?.navigationBar.titleTextAttributes =  [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white //item 字体颜色
        navigationController?.navigationBar.isTranslucent = true
    }
    
}

// MARK: - 系统返回按钮监听扩展相关
/// 导航返回协议
@objc protocol NavigationProtocol {
    /// 导航将要返回方法
    /// - Returns: true: 返回上一界面， false: 禁止返回
    @objc optional func hw_navigationBackClick() -> Bool
}
extension UIViewController: NavigationProtocol {
    /// 导航将要返回方法
    /// - Returns: true: 返回上一界面， false: 禁止返回
    func hw_navigationBackClick() -> Bool {
        return true
    }
}
extension UINavigationController: UINavigationBarDelegate, UIGestureRecognizerDelegate {
    /// 返回按钮点击监听
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        if viewControllers.count < (navigationBar.items?.count)! {
            return true
        }
        var shouldPop = false
        let vc: UIViewController = topViewController!
        if vc.responds(to: #selector(hw_navigationBackClick)) {
            shouldPop = vc.hw_navigationBackClick()
        }
        if shouldPop {
            DispatchQueue.main.async {
                self.popViewController(animated: true)
            }
        } else {
            for subview in navigationBar.subviews {
                if 0.0 < subview.alpha && subview.alpha < 1.0 {
                    UIView.animate(withDuration: 0.25) {
                        subview.alpha = 1.0
                    }
                }
            }
        }
        return false
    }
    // 手势返回监听
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if childViewControllers.count == 1 {
            return false
        } else {
            if topViewController?.responds(to: #selector(hw_navigationBackClick)) != nil {
                return topViewController!.hw_navigationBackClick()
            }
            return true
        }
    }
}

extension UIViewController {
    /// 加载Storyboard方法 
    static func hw_loadStoryboard() -> UIViewController {
        if UIStoryboard(name: "\(self)", bundle: nil).instantiateViewController(withIdentifier: "\(self)") != nil {
            return UIStoryboard(name: "\(self)", bundle: nil).instantiateViewController(withIdentifier: "\(self)")
        } else {
            return self.init()
        }
    }
}


extension UIViewController {
    func stringNameToClass(name:String) -> UIViewController {
        // 1.获取命名空间
        guard let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] else {
            return UIViewController()
        }
        // 2.通过命名空间和类名转换成类
        let cls : AnyClass? = NSClassFromString((clsName as! String) + "." + name)
        guard let clsType = cls as? UIViewController.Type else {
            return UIViewController()
        }
        // 3.通过Class创建对象
        let vc = clsType.init()
        return vc
    }
}
