//
//  NSMutableAttributedString+HWExtension.swift
//  富文本
//
//  Created by 李含文 on 2018/9/26.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

import UIKit

public extension NSMutableAttributedString {
    /// 获取范围
    func hw_allRange() -> NSRange {
        return NSMakeRange(0,length)
    }
    /// 添加中划线
    @discardableResult
    func hw_addMidline(_ lineHeght: Int, _ range: NSRange? = nil) -> NSMutableAttributedString {
        if range == nil {
            addAttributes([.strikethroughStyle:lineHeght], range: hw_allRange())
        } else {
            addAttributes([.strikethroughStyle:lineHeght], range: range!)
        }
        return self
    }
    /// 中划线颜色
    @discardableResult
    func hw_midlineColor(_ color: UIColor, _ range: NSRange? = nil) -> NSMutableAttributedString{
        if range == nil {
            addAttributes([.strikethroughColor:color], range: hw_allRange())
        } else {
            addAttributes([.strikethroughColor:color], range: range!)
        }
        return self
    }
    /// 给文字添加描边
    ///
    /// - Parameter width: 描边宽带
    /// - Returns:
    @discardableResult
    func hw_addStroke(_ width: CGFloat, _ range: NSRange? = nil) -> NSMutableAttributedString {
        if range == nil {
            addAttributes([.strokeWidth:width], range: hw_allRange())
        } else {
            addAttributes([.strokeWidth:width], range: range!)
        }
        return self
    }
    /// 描边颜色
    @discardableResult
    func hw_strokeColor(_ color: UIColor, _ range: NSRange? = nil) -> NSMutableAttributedString {
        if range == nil {
            addAttributes([.strokeColor:color], range: hw_allRange())
        } else {
            addAttributes([.strokeColor:color], range: range!)
        }
        return self
    }
    
    /// 添加字间距
    @discardableResult
    func hw_addSpace(_ space: CGFloat, _ range: NSRange? = nil) -> NSMutableAttributedString {
        if range == nil {
            addAttributes([.kern:space], range: hw_allRange())
        } else {
            addAttributes([.kern:space], range: range!)
        }
        return self
    }
    /// 背景色
    @discardableResult
    func hw_backgroundColor(_ color: UIColor, _ range: NSRange? = nil) -> NSMutableAttributedString {
        if range == nil {
            addAttributes([.backgroundColor:color], range: hw_allRange())
        } else {
            addAttributes([.backgroundColor:color], range: range!)
        }
        return self
    }
    /// 文字颜色
    @discardableResult
    public func hw_color(_ color: UIColor, _ range: NSRange? = nil) -> NSMutableAttributedString {
        if range == nil {
            addAttributes([.foregroundColor:color], range: hw_allRange())
        } else {
            addAttributes([.foregroundColor:color], range: range!)
        }
        return self
    }

    /// 添加下划线
    ///
    /// - Parameter style: <#style description#>
    /// - Returns: <#return value description#>
    @discardableResult
    func hw_addUnderLine(_ style: NSUnderlineStyle, _ range: NSRange? = nil) -> NSMutableAttributedString{
        if range == nil {
            addAttributes([.underlineStyle:style.rawValue], range: hw_allRange())
        } else {
            addAttributes([.underlineStyle:style.rawValue], range: range!)
        }
        return self
    }
    /// 下划线颜色
    @discardableResult
    func hw_underLineColor(_ color: UIColor, _ range: NSRange? = nil) -> NSMutableAttributedString{
        if range == nil {
            addAttributes([.underlineColor:color], range: hw_allRange())
        } else {
            addAttributes([.underlineColor:color], range: range!)
        }
        return self
    }
    
    /// 字体
    @discardableResult
    func hw_font(_ font: UIFont, _ range: NSRange? = nil) -> NSMutableAttributedString{
        if range == nil {
            addAttributes([.font:font], range: hw_allRange())
        } else {
            addAttributes([.font:font], range: range!)
        }
        return self
    }
    /// 系统字体大小
    @discardableResult
    func hw_fontSize(_ size: CGFloat, _ range: NSRange? = nil)->NSMutableAttributedString{
        if range == nil {
            addAttributes([.font:UIFont.systemFont(ofSize: size)], range: hw_allRange())
        } else {
            addAttributes([.font:UIFont.systemFont(ofSize: size)], range: range!)
        }
        return self
    }
    
    /// 添加行间距
    @discardableResult
    func hw_addLineSpace(_ space: CGFloat, _ range: NSRange? = nil) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = space
        style.lineBreakMode = .byCharWrapping
        if range == nil {
            addAttribute(.paragraphStyle, value: style, range: hw_allRange())
        } else {
            addAttribute(.paragraphStyle, value: style, range: range!)
        }
        return self
    }
    /// 拼接富文本
    @discardableResult
    func hw_addAttribute(_ attribute: NSMutableAttributedString) -> NSMutableAttributedString {
        append(attribute)
        return self
    }
    
    /// 添加阴影
    @discardableResult
    func hw_addShadow(_ shadowOffset:CGSize? = nil ,_ color: UIColor? = nil) -> NSMutableAttributedString {
        let shadow = NSShadow.init()
        shadow.shadowColor = color == nil ? UIColor.black : color!
        shadow.shadowOffset = shadowOffset == nil ? CGSize.init(width: 2, height: 2) : shadowOffset!
        addAttributes([NSAttributedStringKey.shadow: shadow], range: hw_allRange())
        return self
    }
}


public extension String {
    /// 字符串转富文本
    func hw_toAttribute() -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self)
    }
}
