//
//  HWMarqueeViewController.swift
//  LHWDome
//
//  Created by 李含文 on 2018/12/22.
//  Copyright © 2018年 李含文. All rights reserved.
//

import UIKit

class HWMarqueeViewController: UIViewController {

    @IBOutlet weak var marquessView: HWMarqueeView!
    @IBOutlet weak var mainView: HWLevelMobileView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hw_setBgColor()
        hw_setTitle("文字跑马灯")
        marquessView.dataSource = self
        marquessView.clickBlock = { (index) in
            print("点击了第\(index)个")
        }
        marquessView.reloadData()
        mainView.content = "具体来说，潮流服饰/家居用品/酒品饮料/家用电器/零食小吃/汽车用品/医疗保健/全部分类按钮没有响应"
    }
    var tag = 0
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if tag == 0 {
            tag = 1
            mainView.content = "垃圾接口 害我加班....."
        } else {
            tag = 0
            mainView.content = "走马灯 走马灯 走马灯 走马灯 走马灯 走马灯 走马灯 走马灯......"
        }
    }

}
extension HWMarqueeViewController: HWMarqueeViewDataSource {
    
    func numberOfItems(_ marqueeView: HWMarqueeView) -> Int {
        return 10
    }
    func marqueeView(_ marqueeView: HWMarqueeView, cellForItemAt index: Int) -> NSAttributedString {
        let str = "【\(index)】"
        let fullStr = "\(str) 我是\(index)号位" as NSString
        let r = fullStr.range(of: str)
        let att = NSMutableAttributedString.init(string: fullStr as String)
        att.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: r)
        return att
    }
}
