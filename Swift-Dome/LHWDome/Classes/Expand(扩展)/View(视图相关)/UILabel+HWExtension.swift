//
//  UILabel+HWExtension.swift
//  LHWDome
//
//  Created by 李含文 on 2018/10/11.
//  Copyright © 2018年 李含文. All rights reserved.
//

import Foundation
import CoreText

extension UILabel {
    
    // 改进写法【推荐】
    private struct RuntimeKey {
        static let isClickActionKey = UnsafeRawPointer.init(bitPattern: "isClickActionKey".hashValue)
        static let isClickEffectKey = UnsafeRawPointer.init(bitPattern: "isClickEffectKey".hashValue)
        static let attributeStringsKey = UnsafeRawPointer.init(bitPattern: "attributeStringsKey".hashValue)
        static let actionBlock = UnsafeRawPointer.init(bitPattern: "actionBlock".hashValue)
        /// ...其他Key声明
    }
    /// ...其他Key声明
    /// 运行时关联
    private var actionBlock: (()->())? {
        set {
            objc_setAssociatedObject(self, UILabel.RuntimeKey.actionBlock!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, UILabel.RuntimeKey.actionBlock!) as? (()->())
        }
    }
    /// 运行时关联
    private var isClickAction: Bool? {
        set {
            objc_setAssociatedObject(self, UILabel.RuntimeKey.isClickActionKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, UILabel.RuntimeKey.isClickActionKey!) as? Bool
        }
    }
    private var isClickEffect: Bool? {
        set {
            objc_setAssociatedObject(self, UILabel.RuntimeKey.isClickEffectKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, UILabel.RuntimeKey.isClickEffectKey!) as? Bool
        }
    }
    private var attributeStrings: NSMutableArray? {
        set {
            objc_setAssociatedObject(self, UILabel.RuntimeKey.attributeStringsKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, UILabel.RuntimeKey.attributeStringsKey!) as? NSMutableArray
        }
    }
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isClickAction == nil {return}
        if !self.isClickAction! {return}
        let touch = touches.first
        
        let point = touch?.location(in: self)
        
        richTextFrameWithTouchPoint(point: point!) { (String, NSRange, Int) in
            if actionBlock == nil {return}
            actionBlock!()
        }
    }
    @discardableResult
    func richTextFrameWithTouchPoint(point:CGPoint, result:((String, NSRange, NSInteger)->())) -> Bool {
        let framesetter = CTFramesetterCreateWithAttributedString(self.attributedText!)
        
        var path = CGMutablePath()
        
        path.addRect(self.bounds, transform: CGAffineTransform.identity)
        
        var frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        
        let range = CTFrameGetVisibleStringRange(frame)
        
        if self.attributedText?.length ?? 0 > range.length {
            var m_font : UIFont
            let n_font = self.attributedText?.attribute(.font, at: 0, effectiveRange: nil)
            if n_font != nil {
                m_font = n_font as! UIFont
            }else if (self.font != nil) {
                m_font = self.font
            }else {
                m_font = UIFont.systemFont(ofSize: 17)
            }
            
            path = CGMutablePath()
            path.addRect(CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height + m_font.lineHeight), transform: CGAffineTransform.identity)
            
            frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        }
        
        let lines = CTFrameGetLines(frame)
        
        if lines == [] as CFArray {
            return false
        }
        
        let count = CFArrayGetCount(lines)
        
        var origins = [CGPoint](repeating: CGPoint.zero, count: count)
        
        CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), &origins)
        
        let transform = CGAffineTransform(translationX: 0, y: self.bounds.size.height).scaledBy(x: 1.0, y: -1.0);
        
        let verticalOffset = 0.0
        
        for i : CFIndex in 0..<count {
            
            let linePoint = origins[i]
            
            let line = CFArrayGetValueAtIndex(lines, i)
            
            let lineRef = unsafeBitCast(line,to: CTLine.self)
            
            let flippedRect : CGRect = yb_getLineBounds(lineRef , point: linePoint)
            
            var rect = flippedRect.applying(transform)
            
            rect = rect.insetBy(dx: 0, dy: 0)
            
            rect = rect.offsetBy(dx: 0, dy: CGFloat(verticalOffset))
            
            let style = self.attributedText?.attribute(.paragraphStyle, at: 0, effectiveRange: nil)
            
            var lineSpace : CGFloat = 0.0
            
            if (style != nil) {
                lineSpace = (style as! NSParagraphStyle).lineSpacing
            }else {
                lineSpace = 0.0
            }
            
            let lineOutSpace = (CGFloat(self.bounds.size.height) - CGFloat(lineSpace) * CGFloat(count - 1) - CGFloat(rect.size.height) * CGFloat(count)) / 2
            
            rect.origin.y = lineOutSpace + rect.size.height * CGFloat(i) + lineSpace * CGFloat(i)
            
            if rect.contains(point) {
                
                let relativePoint = CGPoint(x: point.x - rect.minX, y: point.y - rect.minY)
                
                var index = CTLineGetStringIndexForPosition(lineRef, relativePoint)
                
                var offset : CGFloat = 0.0
                
                CTLineGetOffsetForStringIndex(lineRef, index, &offset)
                
                if offset > relativePoint.x {
                    index = index - 1
                }
                
                let link_count = attributeStrings?.count
                
                for j in 0 ..< link_count! {
                    
                    let model = attributeStrings![j] as! YBAttributeModel
                    
                    let link_range = (model).range
                    if NSLocationInRange(index-1, link_range!) {
                        result(model.str ?? "",model.range ?? NSRange.init(),j)
                        return true
                    }
                }
            }
        }
        return false
        
    }
    fileprivate func yb_getLineBounds(_ line : CTLine , point : CGPoint) -> CGRect {
        var ascent : CGFloat = 0.0;
        var descent : CGFloat = 0.0;
        var leading  : CGFloat = 0.0;
        
        let width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading)
        
        let height = ascent + fabs(descent) + leading
        
        return CGRect.init(x: point.x, y: point.y , width: CGFloat(width), height: height)
    }
    func clickRichTextWithStrings(strings: NSArray, clickAction: @escaping (()->())) {
        self.isUserInteractionEnabled = true
        self.richTextRangesWithStrings(strings: strings)
        self.actionBlock = clickAction
    }
    func richTextRangesWithStrings(strings: NSArray) {
        if self.attributedText == nil {
            self.isClickAction = false
            return
        }
        self.isClickAction = true
        self.isClickEffect = true
        yb_getRange(strings as! [String])
//        var totalStr = self.attributedText?.string
//        self.attributeStrings = NSMutableArray()
//        strings.enumerateObjects { (obj, idx, stop) in
//            if totalStr == nil {return}
//            let range: Range = totalStr!.range(of: obj as! String)!
//            let nsrange = totalStr!.nsRange(from: range)
//            if nsrange.length != 0 {
////                totalStr = totalStr.
//            }
//        }
    }
    
    // MARK: - getRange
    fileprivate func yb_getRange(_ strings :  [String]) -> Void {
        
        if self.attributedText?.length == 0 {
            return;
        }
        
        self.isUserInteractionEnabled = true
        
        var totalString = self.attributedText?.string
        
        attributeStrings = [];
        
        for str : String in strings {
            let range = totalString?.range(of: str)
            if (range?.lowerBound != nil) {
                
                totalString = totalString?.replacingCharacters(in: range!, with: self.yb_getString(str.count))
                
                let model = YBAttributeModel()
                model.range = totalString?.nsRange(from: range!)
                model.str = str
                
                attributeStrings?.add(model)
            }
        }
    }
    fileprivate func yb_getString(_ count : Int) -> String {
        var string = ""
        for _ in 0 ..< count {
            string = string + " "
        }
        return string
    }
}

extension String {
   
    /// range转换为NSRange
    func nsRange(from range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }

    /// 字符串的匹配范围 方法一
    ///
    /// - Parameters:
    /// - matchStr: 要匹配的字符串
    /// - Returns: 返回所有字符串范围
//    @discardableResult
//    func hw_exMatchStrRange(_ matchStr: String) -> [NSRange] {
//        var allLocation = [Int]() //所有起点
//        let matchStrLength = (matchStr as NSString).length  //currStr.characters.count 不能正确统计表情
//
//        let arrayStr = self.components(separatedBy: matchStr)//self.componentsSeparatedByString(matchStr)
//        var currLoc = 0
//        arrayStr.forEach { currStr in
//            currLoc += (currStr as NSString).length
//            allLocation.append(currLoc)
//            currLoc += matchStrLength
//        }
//        allLocation.removeLast()
//        return allLocation.map { NSRange(location: $0, length: matchStrLength) } //可把这段放在循环体里面，同步处理，减少再次遍历的耗时
//    }
    
    /// 字符串的匹配范围 方法二(推荐)
    ///
    /// - Parameters:
    ///     - matchStr: 要匹配的字符串
    /// - Returns: 返回所有字符串范围
    @discardableResult
    func hw_exMatchStrRange(_ matchStr: String) -> [NSRange] {
        var selfStr = self as NSString
        var withStr = Array(repeating: "X", count: (matchStr as NSString).length).joined(separator: "") //辅助字符串
        if matchStr == withStr { withStr = withStr.lowercased() } //临时处理辅助字符串差错
        var allRange = [NSRange]()
        while selfStr.range(of: matchStr).location != NSNotFound {
            let range = selfStr.range(of: matchStr)
            allRange.append(NSRange(location: range.location,length: range.length))
            selfStr = selfStr.replacingCharacters(in: NSMakeRange(range.location, range.length), with: withStr) as NSString
        }
        return allRange
    }

    
    
}
private class YBAttributeModel: NSObject {
    
    var range : NSRange?
    var str : String?
}

