//
//  NSMutableAttributedStringExtensionViewController.swift
//  LHWDome
//
//  Created by 李含文 on 2018/9/29.
//  Copyright © 2018年 李含文. All rights reserved.
//

import UIKit

class NSMutableAttributedStringExtensionViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle(title: "富文本扩展")
        setBGColor()
        setUI()
    }

    func setUI() {
        var str = "我不要种田 我要当老板我我我"
        let array = str.hw_exMatchStrRange("我")
        let array1 = str.hw_exMatchStrRange("我")
        // MARK: - 修改颜色
        let textLabel = UILabel.init(frame: CGRect.init(x: 20, y: 100, width: UIScreen.main.bounds.size.width - 40, height: 30))
        view.addSubview(textLabel)
        textLabel.attributedText = str.hw_toAttribute()
            .hw_color(UIColor.gray)
        textLabel.clickRichTextWithStrings(strings: ["我","要","当"]) {
            print("来了")
        }
        
        // MARK: - 删除线
        let textLabel2 = UILabel.init(frame: CGRect.init(x: 20, y: 130, width: UIScreen.main.bounds.size.width - 40, height: 30))
        view.addSubview(textLabel2)
        textLabel2.attributedText = str.hw_toAttribute()
            .hw_addMidline(1)
            .hw_midlineColor(UIColor.red)
        
        // MARK: - 文字大小
        let textLabel3 = UILabel.init(frame: CGRect.init(x: 20, y: 160, width: UIScreen.main.bounds.size.width - 40, height: 30))
        textLabel3.textColor = UIColor.red
        view.addSubview(textLabel3)
        textLabel3.attributedText = str.hw_toAttribute()
            .hw_fontSize(25)
        
        // MARK: - 字体颜色
        let textLabel4 = UILabel.init(frame: CGRect.init(x: 20, y: 190, width: UIScreen.main.bounds.size.width - 40, height: 30))
        view.addSubview(textLabel4)
        textLabel4.attributedText =  str.hw_toAttribute()
            .hw_color(UIColor.red)
        
        // MARK: - 背景色
        let textLabel5 = UILabel.init(frame: CGRect.init(x: 20, y: 220, width: UIScreen.main.bounds.size.width - 40, height: 30))
        view.addSubview(textLabel5)
        textLabel5.attributedText =  str.hw_toAttribute()
            .hw_backgroundColor(UIColor.blue)
        
        // MARK: - 阴影
        let textLabel6 = UILabel.init(frame: CGRect.init(x: 20, y: 250, width: UIScreen.main.bounds.size.width - 40, height: 30))
        view.addSubview(textLabel6)
        textLabel6.attributedText = str.hw_toAttribute()
            .hw_addShadow()
        
        // MARK: - 下划线
        let textLabel7 = UILabel.init(frame: CGRect.init(x: 20, y: 280, width: UIScreen.main.bounds.size.width - 40, height: 30))
        view.addSubview(textLabel7)
        textLabel7.attributedText = str.hw_toAttribute()
            .hw_addUnderLine(.styleSingle)
            .hw_underLineColor(UIColor.yellow)
        
        // MARK: - 拼接
        let textLabel8 = UILabel.init(frame: CGRect.init(x: 20, y: 310, width: UIScreen.main.bounds.size.width - 40, height: 30))
        view.addSubview(textLabel8)
        textLabel8.attributedText = str.hw_toAttribute()
            .hw_addUnderLine(.styleSingle)
            .hw_underLineColor(UIColor.yellow).hw_addAttribute("我是拼接的".hw_toAttribute().hw_color(UIColor.red))
    }
    

}
