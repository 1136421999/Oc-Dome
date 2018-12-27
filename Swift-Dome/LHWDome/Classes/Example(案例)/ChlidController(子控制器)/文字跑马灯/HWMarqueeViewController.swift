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
    override func viewDidLoad() {
        super.viewDidLoad()
        setBGColor()
        setTitle(title: "文字跑马灯")
        marquessView.dataSource = self
        marquessView.clickBlock = { (index) in
            print("点击了第\(index)个")
        }
        marquessView.reloadData()
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
