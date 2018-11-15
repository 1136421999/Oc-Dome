//
//  UIButton+HWExtension.swift
//  BBCShop
//
//  Created by Hanwen on 2018/1/13.
//  Copyright © 2018年 SK丿希望. All rights reserved.
//

import UIKit

// MARK: - 快速设置按钮 并监听点击事件
typealias  buttonClick = (()->()) // 定义数据类型(其实就是设置别名)
extension UIButton{
    
    // 改进写法【推荐】
    private struct RuntimeKey {
        static let actionBlock = UnsafeRawPointer.init(bitPattern: "actionBlock".hashValue)
        /// ...其他Key声明
    }
    /// 运行时关联
    private var actionBlock: buttonClick? {
        set {
            objc_setAssociatedObject(self, UIButton.RuntimeKey.actionBlock!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, UIButton.RuntimeKey.actionBlock!) as? buttonClick
        }
    }
    /// 点击回调
    @objc private func tapped(button:UIButton){
        if self.actionBlock != nil {
            self.actionBlock!()
        }
    }
    /// 添加点击事件
    func addAction(action:@escaping buttonClick) {
        self.addTarget(self, action:#selector(tapped(button:)) , for:.touchUpInside)
        self.actionBlock = action
    }
    /// 快速创建
    convenience init(setImage:String, action:@escaping buttonClick){
        self.init()
        self.frame = frame
        self.setImage(UIImage(named:setImage), for: UIControlState.normal)
        self.addAction {
            action()
        }
        self.sizeToFit()
    }
    /// 快速创建
    convenience init(action:@escaping buttonClick){
        self.init()
        self.addAction {
            action()
        }
        self.sizeToFit()
    }
    /// 快速创建按钮 setImage: 图片名 frame:frame action:点击事件的回调
    convenience init(setImage:String, frame:CGRect, action: @escaping buttonClick){
        self.init( setImage: setImage, action: action)
        self.frame = frame
    }
    convenience init(titleString:String, action:@escaping buttonClick){
        self.init()
        self.frame = frame
        self.setTitle(titleString, for: .normal)
        self.addAction {
            action()
        }
        self.sizeToFit()
    }
    /// 快速创建按钮 titleString:title  frame:frame action:点击事件的回调
    convenience init(titleString:String, frame:CGRect, action: @escaping buttonClick){
        self.init(titleString: titleString, action: action)
        self.frame = frame
    }
}

// MARK: - 倒计时
extension UIButton{
    // MARK:倒计时 count:多少秒 默认倒计时的背景颜色gray
    /// 倒计时 count:多少秒 默认倒计时的背景颜色gray
    @discardableResult
    public func countDown(count: Int) -> UIButton {
        self.countDown(count: count, countDownBgColor: UIColor.gray)
        return self
    }
    // MARK:倒计时 count:多少秒 countDownBgColor:倒计时背景颜色
    /// 倒计时 count:多少秒 countDownBgColor:倒计时背景颜色
    @discardableResult
    public func countDown(count: Int,countDownBgColor:UIColor) -> UIButton {
        // 倒计时开始,禁止点击事件
        isEnabled = false
        // 保存当前的背景颜色
        let defaultColor = self.backgroundColor
        // 设置倒计时,按钮背景颜色
        backgroundColor = countDownBgColor
        var remainingCount: Int = count {
            willSet {
                titleLabel?.text = "\(newValue)s"
                setTitle("\(newValue)s", for: .normal)
                if newValue <= 0 {
                    titleLabel?.text = "发送验证码"
                    setTitle("发送验证码", for: .normal)
                }
            }
        }
        // 在global线程里创建一个时间源
        let codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
        // 设定这个时间源是每秒循环一次，立即开始
        codeTimer.schedule(deadline: .now(), repeating: .seconds(1))
        // 设定时间源的触发事件
        codeTimer.setEventHandler(handler: {
            // 返回主线程处理一些事件，更新UI等等
            DispatchQueue.main.async {
                // 每秒计时一次
                remainingCount -= 1
                // 时间到了取消时间源
                if remainingCount <= 0 {
                    self.backgroundColor = defaultColor
                    self.isEnabled = true
                    codeTimer.cancel()
                }
            }
        })
        // 启动时间源
        codeTimer.resume()
        return self
    }
}
// MARK: - 调整位置相关
enum HWButtonMode {
    case Top
    case Bottom
    case Left
    case Right
}
extension UIButton {
    /// 快速调整图片与文字位置
    ///
    /// - Parameters:
    ///   - buttonMode: 图片所在位置
    ///   - spacing: 文字和图片之间的间距
    @discardableResult
    func hw_locationAdjust(buttonMode: HWButtonMode,
                           spacing: CGFloat) -> UIButton {
        let imageSize = self.imageRect(forContentRect: self.frame)
        let titleFont = self.titleLabel?.font!
        let titleSize = titleLabel?.text?.size(withAttributes: [kCTFontAttributeName as NSAttributedStringKey: titleFont!]) ?? CGSize.zero
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        switch (buttonMode){
        case .Top:
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing)/2,
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing)/2, left: 0, bottom: 0, right: -titleSize.width)
        case .Bottom:
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing)/2,
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing)/2, left: 0, bottom: 0, right: -titleSize.width)
        case .Left:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .Right:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0,
                                       right: -(titleSize.width * 2 + spacing))
        }
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
        return self
    }
}
