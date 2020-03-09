//
//  UILabelExtensionViewController.swift
//  LHWDome
//
//  Created by 李含文 on 2018/11/21.
//  Copyright © 2018年 李含文. All rights reserved.
//

import UIKit

class UILabelExtensionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        hw_setBgColor()
        hw_setTitle("label点击事件")
        var label : UILabel
        label = UILabel.init(frame: CGRect.init(x: 10, y: 100, width: 350, height: 100))
        let str = "这是一个swfit Label,用与给Label扩展点击事件"
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.text = str
        label.hw_addTapAction(["这","swfit","Label"]) { (string, range, int) in
            print("点击了\(string)标签 - {\(range.location) , \(range.length)} - \(int)")
        }
        self.view.addSubview(label)
    }



}
