//
//  BaseViewController.swift
//  BBCShop
//
//  Created by 梁琪琛 on 2018/2/9.
//  Copyright © 2018年 SK丿希望. All rights reserved.
//

import UIKit


class BaseViewController: UIViewController {
    private var themeColor = UIColor.white
    override func viewDidLoad() {
        switchNavColor(HWMainColor())
        super.viewDidLoad()
//        setBGColor()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("进入了---\(type(of: self))")
    }
    deinit {
        print("\(type(of: self))释放")
        NotificationCenter.default.removeObserver(self)
    }
    public func setBackBtn(_ tintColor: UIColor = .black) {
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "返回白"), style: UIBarButtonItem.Style.done, target: self, action: #selector(backBtnClick))//
        leftBarButtonItem.tintColor = tintColor
        if #available(iOS 11.0, *){ // ios11 以上偏移
            leftBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: -11, bottom: 0, right: 0)
            navigationItem.leftBarButtonItem = leftBarButtonItem
        } else {
            let nagetiveSpacer = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
            nagetiveSpacer.width = -11//这个值可以根据自己需要自己调整
            navigationItem.leftBarButtonItems = [nagetiveSpacer, leftBarButtonItem]
        }
        if (navigationController?.viewControllers.count ?? 0) > 1 {
            navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate // 重要 自定义返回按钮恢复返回手势
        }
    }
    @objc private func backBtnClick() {
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    /// 修改导航栏颜色
    ///
    /// - Parameter color: 需要修改的颜色
    func switchNavColor(_ color: UIColor) {
        themeColor = color
        navigationController?.navigationBar.setBackgroundImage(UIImage(color: color, size: UIScreen.main.bounds.size), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        //                navigationController?.navigationBar.isTranslucent = true // 会觉得颜色很浅，因为这是半透明状态 iOS11 以下出现内容上偏
        navigationController?.navigationBar.isTranslucent = false // 推荐关闭半透明状态 导航栏位置 相对布局以0开始
        UIApplication.shared.statusBarStyle = color != UIColor.white ? .lightContent : .default
        navigationController?.navigationBar.titleTextAttributes =  [NSAttributedString.Key.foregroundColor: color != UIColor.white ? UIColor.white : UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize:18)]
        navigationController?.navigationBar.tintColor = color != UIColor.white ? UIColor.white : UIColor.black //item 字体颜色
        setNeedsStatusBarAppearanceUpdate()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return themeColor != UIColor.white ? .lightContent : .default
    }
}

