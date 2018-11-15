//
//  UITextFieldExtensionViewController.swift
//  LHWDome
//
//  Created by 李含文 on 2018/9/29.
//  Copyright © 2018年 李含文. All rights reserved.
//

import UIKit

class UITextFieldExtensionViewController: BaseViewController {
    @IBOutlet weak var moneyTF: UITextField!
    @IBOutlet weak var two: UITextField!
    @IBOutlet weak var tf: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle(title: "UITextField扩展")
        moneyTF.hw.isMoeeyEidtor(true).endEditingBlock = { (text) in
            print("输入金额为:\(text)")
        }
        tf.hw.valuesChangeBlock = {
            print("第一个:\($0)")
        }
        tf.hw.beginEditingBlock = {
            print("第一个开始输入")
        }
        tf.hw.endEditingBlock = {
            print("第一个最终输入:\($0)")
        }
        two.hw.valuesChangeBlock = {
            print("第二个:\($0)")
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}
