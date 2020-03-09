//
//  UIApplication+HWExtension.swift
//  jzyd
//
//  Created by 李含文 on 2018/11/1.
//  Copyright © 2018年 李含文. All rights reserved.
//

import Foundation


extension UIApplication {
    /// 快速回主线程
    class func hw_getMainThread(_ action:@escaping (()->())) {
        DispatchQueue.main.async {
            action()
        }
    }
    /// 快速获取app版本
    class func hw_getVersion() -> String {
        let infoDictionary = Bundle.main.infoDictionary!
        let appVersion = infoDictionary["CFBundleShortVersionString"] as! String//app版本号
        return appVersion
    }
    
    /// 获取栈顶控制器
    ///
    /// - Parameter controller:
    /// - Returns: 返回
    class func hw_getTopViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController { // 如果更控制器是导航控制器
            return hw_getTopViewController(controller: navigationController.visibleViewController) // 拿当前根控制器中显示的控制器
        }
        if let tabController = controller as? UITabBarController { // 如果是 tabController
            if let selected = tabController.selectedViewController { // 拿选中的 作为跟控制器去拿
                return hw_getTopViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return hw_getTopViewController(controller: presented)
        }
        return controller
    }
    
    ///  倒计时
    ///
    /// - Parameters:
    ///   - time: 倒计时多少秒
    ///   - action: 时间到的回调
    /// - Returns: DispatchSourceTimer
    class func hw_countdown(_ time: Int, _ action:@escaping (()->())) -> DispatchSourceTimer {
        var remainingCount = time
        let codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global()) // 在global线程里创建一个时间源
        codeTimer.schedule(deadline: .now(), repeating: .seconds(1)) // 设定这个时间源是每秒循环一次，立即开始
        // 设定时间源的触发事件
        codeTimer.setEventHandler(handler: {
            remainingCount -= 1 // 每秒计时一次
            if remainingCount <= 0 { // 时间到了取消时间源
                codeTimer.cancel()
                DispatchQueue.main.async { // 返回主线程处理一些事件，更新UI等等
                    action()
                }
            }
        })
        codeTimer.resume()  // 启动时间源
        return codeTimer
    }
}
