//
//  UIColor+HWExtension.swift
//  LHWDome
//
//  Created by 李含文 on 2018/9/13.
//  Copyright © 2018年 李含文. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 颜色渐变
enum HWGradientDirection{ // 渐变方向
    /// 左到右
    case LeftToRight // 没有
    /// 上到下
    case TopToBottom // 浏览记录
}

extension UIColor {
    
    //返回随机颜色
    open class var randomColor : UIColor {
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
    /// 颜色16字符串进制转颜色
    class func hw_color(hex:String, alpha:CGFloat? = nil) -> UIColor {
        var cString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") {
            let index = cString.index(after: cString.startIndex)
            cString = String(cString[cString.index(after: index)])
        }
        if cString.count != 6 {
            return UIColor.black
        }
        let rRange = cString.startIndex ..< cString.index(cString.startIndex, offsetBy: 2)
        let rString = String(cString[rRange])
        
        let gRange = cString.index(cString.startIndex, offsetBy: 2) ..< cString.index(cString.startIndex, offsetBy: 4)
        let gString = String(cString[gRange])
        
        let bRange = cString.index(cString.startIndex, offsetBy: 4) ..< cString.index(cString.startIndex, offsetBy: 6)
        let bString = String(cString[bRange])
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: (alpha == nil ? 1 : alpha!))
    }
    /// r/g/b/alpha创建颜色 alpha不传默认为1
    convenience init(_ r : CGFloat, _ g : CGFloat, _ b : CGFloat, _ alpha : CGFloat? = nil) {
        let red = r / 255.0
        let green = g / 255.0
        let blue = b / 255.0
        self.init(red: red, green: green, blue: blue, alpha: (alpha == nil ? 1 : alpha!))
    }
    /// 颜色16int类型转颜色
    class func hw_color(hex:UInt32, alpha:CGFloat? = nil) -> UIColor{
        let r:CGFloat = (CGFloat)((hex >> 16) & 0xFF)
        let g:CGFloat = (CGFloat)((hex >> 8) & 0xFF)
        let b:CGFloat = (CGFloat)(hex & 0xFF)
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha == nil ? 1 : alpha!)
    }
    
    /// 渐变颜色
    ///
    /// - Parameters:
    ///   - direction: 渐变方向
    ///   - startHex: 开始颜色的hex值
    ///   - endHex: 结束颜色的hex值
    ///   - frame: 需要渐变的尺寸
    /// - Returns: 渐变色
    static func hw_color(_ direction:HWGradientDirection,_ startHex:String,_ endHex:String ,_ frame:CGRect? = nil) -> UIColor{
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame == nil ? UIScreen.main.bounds : frame!
        gradientLayer.colors = [startHex.hw_hexColor().cgColor, endHex.hw_hexColor().cgColor]

        switch direction {
        case .LeftToRight:
            gradientLayer.startPoint = CGPoint.init(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint.init(x: 1, y: 0.5)
            UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size,false, UIScreen.main.scale);
            gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
            let backgroundColorImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return UIColor(patternImage: backgroundColorImage!)
        case .TopToBottom:
            UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size,false, UIScreen.main.scale);
            gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
            let backgroundColorImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return UIColor(patternImage: backgroundColorImage!)
        }
    }
}

///MARK: - 字符串转颜色
extension String {
    /// 字符串转颜色
    ///
    /// - Parameter alpha: 颜色透明度(0-1) 如果为nil默认为1
    /// - Returns: 颜色
    func hw_hexColor(_ alpha : CGFloat? = nil) -> UIColor{
        let scanner = Scanner(string: self)
        var hexNum:UInt32 = 0
        if scanner.scanHexInt32(&hexNum) == false {
            print("输入的String类型位数不足6位直接转为红色")
            return UIColor.red
        }
        return UIColor.hw_color(hex: hexNum, alpha: alpha == nil ? 1 : alpha!)
    }
}

extension Int {
    /// Int转颜色
    ///
    /// - Parameter alpha: 颜色透明度(0-1) 如果为nil默认为1
    /// - Returns: 颜色
    func hw_hexColor(_ alpha : CGFloat? = nil) -> UIColor {
        if self > 10000 && self < 1000000 {
            return String(format: "%ld", self).hw_hexColor(alpha)
        }
        print("输入的Int类型位数不足6位直接转为红色")
        return UIColor.red
    }
}


extension UIColor {
    /// MARK: - 颜色转图片
    func hw_toImage() -> UIImage{
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(self.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}


