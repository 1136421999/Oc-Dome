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
    @IBOutlet weak var button4: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        hw_setTitle("按钮扩展")
        hw_setBgColor()
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
        button4.hw_clickEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
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
    @IBAction func btn_4Click(_ sender: Any) {
        HUDManage?.hw_showtitleHUD(name: "点击了按钮")
    }
    
}
