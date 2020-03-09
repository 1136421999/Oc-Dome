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
        hw_setTitle("UITextField扩展")
        moneyTF.placeholderColor = UIColor.black
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
//    func createOverlay(frame : CGRect) {
//        let overlayView = UIView(frame: frame)
//        overlayView.alpha = 0.6
//        overlayView.backgroundColor = UIColor.black
//        self.view.addSubview(overlayView)
//        
//        let maskLayer = CAShapeLayer()
//        
//        // Create a path with the rectangle in it.
//        var path = CGMutablePath()
//        
//        let radius : CGFloat = 50.0
//        let xOffset : CGFloat = 10
//        let yOffset : CGFloat = 10
//        
//        CGPath.
//        CGPathAddArc(path, nil, overlayView.frame.width - radius/2 - xOffset, yOffset, radius, 0.0, 2 * 3.14, false)
//        
//        CGPathAddRect(path, nil, CGRectMake(0, 0, overlayView.frame.width, overlayView.frame.height))
//        
//        
//        maskLayer.backgroundColor = UIColor.black.cgColor
//        
//        maskLayer.path = path;
//        maskLayer.fillRule = kCAFillRuleEvenOdd
//        
//        // Release the path since it's not covered by ARC.
//        overlayView.layer.mask = maskLayer
//        overlayView.clipsToBounds = true
//    }
}
