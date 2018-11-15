//
//  UIView+HWExtension.swift
//  BBCShop
//
//  Created by Hanwen on 2018/1/13.
//  Copyright © 2018年 SK丿希望. All rights reserved.
//

import UIKit

public extension UIView{
    // MARK: - 尺寸相关
    // MARK: - 尺寸相关
    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            var center = self.center
            center.x = newValue
            self.center = center
        }
    }
    
    var centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            var center = self.center
            center.y = newValue
            self.center = center
        }
    }
    
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    var size : CGSize{
        get{
            return self.frame.size
        }
        set{
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
    var origin : CGPoint{
        get{
            return self.frame.origin
        }
        set{
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }
    // 关联 SB 和 XIB
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    @IBInspectable public var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    @IBInspectable public var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable public var shadowColor: UIColor? {
        get {
            return layer.shadowColor != nil ? UIColor(cgColor: layer.shadowColor!) : nil
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    @IBInspectable public var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    @IBInspectable public var zPosition: CGFloat {
        get {
            return layer.zPosition
        }
        
        set {
            layer.zPosition = newValue
        }
    }
    
    // MARK: - 尺寸裁剪相关
    /// 添加圆角 以高度为半径裁剪
    func addRounded() {
        addRounded(radius: self.height/2)
    }
    /// 添加圆角  radius: 圆角半径
    func addRounded(radius:CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    /// 添加部分圆角 corners: 需要实现为圆角的角，可传入多个 radius: 圆角半径
    func addRounded(radius:CGFloat, corners: UIRectCorner) {
//    使用  buttomView.addRounded(radius: 6, corners:  [UIRectCorner.bottomLeft,UIRectCorner.bottomRight])
        let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize.init(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer;
    }

    
    // 添加圆角和阴影
    func addRoundedOrShadow(radius:CGFloat, shadowOpacity:CGFloat, shadowColor:UIColor)  {
        self.layer.cornerRadius = radius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = Float(shadowOpacity)
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false

    }
    // 添加圆角和阴影
    func addRoundedOrShadow(shadowOpacity:CGFloat, shadowColor:UIColor)  {
        self.layer.cornerRadius = self.height/2
        self.layer.masksToBounds = true
        let subLayer = CALayer()
        let fixframe = self.frame
        let newFrame = CGRect(x: fixframe.minX-(375-HWScreenW())/2, y: fixframe.minY, width: fixframe.width, height: fixframe.height)
        subLayer.frame = newFrame
        subLayer.cornerRadius = self.height/2
        subLayer.backgroundColor = UIColor.white.cgColor
        subLayer.masksToBounds = false
        subLayer.shadowColor = shadowColor.cgColor // 阴影颜色
        subLayer.shadowOffset = CGSize(width: 0, height: 0) // 阴影偏移,width:向右偏移3，height:向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        subLayer.shadowOpacity = Float(shadowOpacity) //阴影透明度
        subLayer.shadowRadius = 5;//阴影半径，默认3
        self.superview?.layer.insertSublayer(subLayer, below: self.layer)
    }
    // 添加阴影
    func addShadow(shadowOpacity:Float, shadowColor:UIColor)  {
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 4
    }
}

// MARK: - 从xib加载view
extension UIView {
    /// 从xib加载view
    static func hw_loadViewFromNib() -> UIView {
        if (Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.last != nil) {
            return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.last as! UIView
        } else {
           return self.init()
        }
    }
}
// MARK: - 边框相关
enum HWBorderType {
    case Left
    case Right
    case Top
    case Bottom
}
extension UIView {
    
    /// 添加边框可自定义边框位置 不支持圆角
    func hw_addBorder(_ borderTypes:[HWBorderType], _ borderWidth: CGFloat, _ borderColor: UIColor) {
        if borderTypes.contains(.Top) {
            let topLayer = CALayer.init()
            topLayer.backgroundColor = borderColor.cgColor
            topLayer.frame = CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: borderWidth)
            self.layer.addSublayer(topLayer)
        }
        if borderTypes.contains(.Left) {
            let leftLayer = CALayer.init()
            leftLayer.backgroundColor = borderColor.cgColor
            leftLayer.frame = CGRect.init(x: 0, y: 0, width: borderWidth, height: self.bounds.size.height)
            self.layer.addSublayer(leftLayer)
        }
        if borderTypes.contains(.Right) {
            let rightLayer = CALayer.init()
            rightLayer.backgroundColor = borderColor.cgColor
            rightLayer.frame = CGRect.init(x: self.bounds.size.width-borderWidth, y: 0, width: borderWidth, height: self.bounds.size.height)
            self.layer.addSublayer(rightLayer)
        }
        if borderTypes.contains(.Bottom) {
            let bottomLayer = CALayer.init()
            bottomLayer.backgroundColor = borderColor.cgColor
            bottomLayer.frame = CGRect.init(x: 0, y: self.bounds.size.height - borderWidth, width: self.bounds.size.width, height: borderWidth)
            self.layer.addSublayer(bottomLayer)
        }
    }
    // MARK: 添加边框
    /// 添加边框 width: 边框宽度 默认黑色
    func addBorder(width : CGFloat) { // 黑框
        self.layer.borderWidth = width;
        self.layer.borderColor = UIColor.black.cgColor;
    }
    /// 添加边框 width: 边框宽度 borderColor:边框颜色
    func addBorder(width : CGFloat, borderColor : UIColor) { // 颜色自己给
        self.layer.borderWidth = width;
        self.layer.borderColor = borderColor.cgColor;
    }
}
// MARK: - 毛玻璃效果
extension UIView {
    /// 毛玻璃
    func hw_effectView(alpha:CGFloat) {
        let effect = UIBlurEffect.init(style: UIBlurEffectStyle.light)
        let effectView = UIVisualEffectView.init(effect: effect)
        effectView.frame = self.bounds
        effectView.alpha = alpha
        self.addSubview(effectView)
    }
}
// MARK: - 位移相关
extension UIView {
    /// 移动到指定中心点位置
    func moveToPoint(point:CGPoint) {
        var center = self.center
        center.x = point.x
        center.y = point.y
        self.center = center
    }
    
    /// 缩放到指定大小 scale:(0-1)
    func scaleToSize(scale:CGFloat) {
        var rect = self.frame
        rect.size.width *= scale
        rect.size.height *= scale
        self.frame = rect
    }
}
