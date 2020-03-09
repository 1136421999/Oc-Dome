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
    func hw_addMidline(_ lineHeght: Int) -> NSMutableAttributedString {
        addAttributes([.strikethroughStyle:lineHeght], range: hw_allRange())
        return self
    }
    /// 中划线颜色
    @discardableResult
    func hw_midlineColor(_ color: UIColor) -> NSMutableAttributedString{
        addAttributes([.strikethroughColor:color], range: hw_allRange())
        return self
    }
    /// 给文字添加描边
    ///
    /// - Parameter width: 描边宽带
    /// - Returns:
    @discardableResult
    func hw_addStroke(_ width: CGFloat) -> NSMutableAttributedString {
        addAttributes([.strokeWidth:width], range: hw_allRange())
        return self
    }
    /// 描边颜色
    @discardableResult
    func hw_strokeColor(_ color: UIColor) -> NSMutableAttributedString {
        addAttributes([.strokeColor:color], range: hw_allRange())
        return self
    }
    
    /// 添加字间距
    @discardableResult
    func hw_addSpace(_ space: CGFloat) -> NSMutableAttributedString {
        addAttributes([.kern:space], range: hw_allRange())
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
    func hw_addUnderLine(_ style: NSUnderlineStyle) -> NSMutableAttributedString{
        addAttributes([.underlineStyle:style.rawValue], range: hw_allRange())
        return self
    }
    /// 下划线颜色
    @discardableResult
    func hw_underLineColor(_ color: UIColor) -> NSMutableAttributedString{
        addAttributes([.underlineColor:color], range: hw_allRange())
        return self
    }
    
    /// 字体
    @discardableResult
    func hw_font(_ font: UIFont) -> NSMutableAttributedString{
        addAttributes([.font:font], range: hw_allRange())
        return self
    }
    /// 系统字体大小
    @discardableResult
    func hw_fontSize(_ size: CGFloat)->NSMutableAttributedString{
        addAttributes([.font:UIFont.systemFont(ofSize: size)], range: hw_allRange())
        return self
    }
    
    /// 添加行间距
    @discardableResult
    func hw_addLineSpace(_ space: CGFloat) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = space
        style.lineBreakMode = .byCharWrapping
        addAttribute(.paragraphStyle, value: style, range: hw_allRange())
        return self
    }
    
    /// 添加阴影
    @discardableResult
    func hw_addShadow(_ shadowOffset:CGSize? = nil ,_ color: UIColor? = nil) -> NSMutableAttributedString {
        let shadow = NSShadow.init()
        shadow.shadowColor = color == nil ? UIColor.black : color!
        shadow.shadowOffset = shadowOffset == nil ? CGSize.init(width: 2, height: 2) : shadowOffset!
        addAttributes([NSAttributedString.Key.shadow: shadow], range: hw_allRange())
        return self
    }
    
    
    /// 添加行间距
    @discardableResult
    func hw_addLineSpacing(_ lineSpacing:CGFloat) -> NSMutableAttributedString {
        let paragraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing //大小调整
        self.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: hw_allRange())
        return self
    }
    
    /// 首行缩进2字符
    ///
    /// - Parameter font: 文字大小
    /// - Parameter lineSpacing: 行间距
    /// - Returns: <#return value description#>
    @discardableResult
    func hw_addindentation(_ font:UIFont,_ lineSpacing:CGFloat) -> NSMutableAttributedString {
        let paragraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.headIndent = 0
        let emptylen = font.pointSize * 2
        paragraphStyle.firstLineHeadIndent = emptylen
        paragraphStyle.lineSpacing = lineSpacing //大小调整
        self.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: hw_allRange())
        return self
    }
    
    /// 添加图片
    @discardableResult
    func hw_addImage(_ image: UIImage, _ rect: CGRect) -> NSMutableAttributedString {
        let textAttachment : NSTextAttachment = NSTextAttachment()
        textAttachment.image = image
        textAttachment.bounds = rect
        append(NSAttributedString(attachment: textAttachment))
        return self
    }
    /// 拼接富文本
    @discardableResult
    static func + (left: NSMutableAttributedString, right: NSMutableAttributedString) -> NSMutableAttributedString {
        left.append(right)
        return left
    }
    
    /// 计算字符串的高度
    ///
    /// - Parameter width: 最大宽度
    /// - Returns: 高度
    @discardableResult
    func hw_getHeight(_ width : CGFloat) -> CGFloat {
        let rect = self.boundingRect(with: CGSize.init(width: width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        return rect.size.height
    }
    /// 计算富文本的宽度
    ///
    /// - Parameter height: 最大高度
    /// - Returns: 宽度
    @discardableResult
    func hw_getWidth(_ height: CGFloat) -> CGFloat {
        let rect = self.boundingRect(with: CGSize.init(width: CGFloat(MAXFLOAT), height: height), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        return rect.size.width
    }
}


public extension String {
    /// 字符串转富文本
    func hw_toAttribute() -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self)
    }
}
