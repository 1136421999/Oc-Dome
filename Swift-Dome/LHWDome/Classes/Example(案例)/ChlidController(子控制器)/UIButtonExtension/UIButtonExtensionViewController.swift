//
//  UIButtonExtensionViewController.swift
//  LHWDome
//
//  Created by 李含文 on 2018/9/29.
//  Copyright © 2018年 李含文. All rights reserved.
//

import UIKit

class UIButtonExtensionViewController: BaseViewController {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle(title: "按钮扩展")
        setBGColor()
        rightButton()
        setUI()
    }
    func setUI() {
        button.hw_locationAdjust(buttonMode: .Top, spacing: 10).addAction {
            HWPrint("点击了按钮1")
        }
        button1.hw_locationAdjust(buttonMode: .Left, spacing: 10).addAction {
            HWPrint("点击了按钮2")
        }
        button2.hw_locationAdjust(buttonMode: .Right, spacing: 10).addAction {
            HWPrint("点击了按钮3")
        }
        button3.hw_locationAdjust(buttonMode: .Bottom, spacing: 10).addAction {
            HWPrint("点击了按钮4")
        }
    }
    func rightButton() {
        let btn = UIButton.init(titleString: "测试", frame: CGRect.init(x: 0, y: 0, width: 60, height: 44)) {
            HWPrint("点击了测试按钮")
        }
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btn)
    }
    
    @IBAction func buttonClick(_ btn: UIButton) {
        btn.countDown(count: 60, countDownBgColor: UIColor.gray)
    }
    
}
