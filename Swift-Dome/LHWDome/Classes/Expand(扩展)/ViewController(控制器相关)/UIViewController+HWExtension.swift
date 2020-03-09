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
    ///
    /// - Parameter color: 颜色/颜色16进制字符串(不传给定默认颜色)
    func hw_setBgColor(_ color: Any? = nil) {
        guard (color != nil) else {
            view.backgroundColor = hw_BGColor
            return
        }
        if color is UIColor {
            view.backgroundColor = color as? UIColor
        } else if color is String {
            view.backgroundColor = (color as? String ?? "").hw_hexColor()
        } else {
            view.backgroundColor = hw_BGColor
        }
    }
    /// 快速设置title
    func hw_setTitle(_ title:String) {
        navigationItem.title = title
    }
    /// 快速设置白色titleView
    func setTitleLabel(title:String) {
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 44))
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.white
        label.text = title
        label.textAlignment = .center
        label.sizeToFit() // 自适应
        self.navigationItem.titleView = label
    }
}
// MARK: - 跳转相关
extension UIViewController {
    /// 快速push到指定控制器
    ///
    /// - Parameter name: 控制器名/控制器
    func hw_pushController(_ name: Any) {
        if name is String {
            pushSetController(name: name as! String)
        } else if name is UIViewController {
            navigationController?.pushViewController(name as! UIViewController, animated: true)
        } else {
            HWPrint("传入:\(name) 异常")
        }
    }
    
    @discardableResult
    private func pushSetController(name:String) -> UIViewController {
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
        self.navigationController?.pushViewController(vc, animated: true)
        return vc
    }
    
    /// 快速返回自定界面
    ///
    /// - Parameter name: 控制器名字符串/控制器(不传默认返回根控制器)
    func hw_popToViewController(_ name:Any? = nil) {
        guard name != nil else { // 不传直接放回根控制器
            navigationController?.popToRootViewController(animated: true)
            return
        }
        if name is String {
            popToViewController(name: name as! String)
        } else if name is UIViewController {
            navigationController?.popToViewController(name as! UIViewController, animated: true)
        } else {
            HWPrint("传入:\(String(describing: name)) 异常")
        }
    }
    
    /// 快速返回指定的控制器 name:要返回的控制器名 (注意:要返回的控制器必须在navigationController的子控制器数组中)
    private func popToViewController(name:String) { // 使用 self.popToViewController(name: "JYKMeViewController")
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
        for i in 0..<(self.navigationController?.viewControllers.count ?? 0) {
            let controller = self.navigationController!.viewControllers[i]
            if controller.isKind(of: cls!) {
                self.navigationController?.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    /// 快速model到指定页面
    ///
    /// - Parameter name: 控制器名
    func hw_presentController(_ name:String) {
        presentSetController(name: name, action: {})
    }
    /// 跳转xib并添加导航栏
    @discardableResult
    private func presentSetController(name:String, action:@escaping (()->())) -> UIViewController {
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
    /// 修改导航栏颜色
    ///
    /// - Parameter color: 需要修改的颜色
    func hw_switchNavColor(_ color: UIColor) {
        navigationController?.navigationBar.setBackgroundImage(UIImage(color: color, size: UIScreen.main.bounds.size), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        //                navigationController?.navigationBar.isTranslucent = true // 会觉得颜色很浅，因为这是半透明状态 iOS11 以下出现内容上偏
        navigationController?.navigationBar.isTranslucent = false // 推荐关闭半透明状态 导航栏位置 相对布局以0开始
        UIApplication.shared.statusBarStyle = color != UIColor.white ? .lightContent : .default
        navigationController?.navigationBar.titleTextAttributes =  [NSAttributedString.Key.foregroundColor: color != UIColor.white ? UIColor.white : UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize:18)]
        navigationController?.navigationBar.tintColor = color != UIColor.white ? UIColor.white : UIColor.black //item 字体颜色
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
