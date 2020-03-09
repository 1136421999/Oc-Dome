//
//  String+HWExtension.swift
//  LHWDome
//
//  Created by 李含文 on 2018/9/13.
//  Copyright © 2018年 李含文. All rights reserved.
//

import Foundation
import UIKit

extension String {
    // MARK: 字符串截取
    /// 字符串截取
    ///
    /// - Parameters:
    ///   - from: 开始位置 from: 为nil时默认从第0为开始
    ///   - to:   结束位置 to:   为nil时默认截取到最后一位
    /// - Returns: 截取字符串
    func hw_substring(from: Int?, to: Int? = nil) -> String {
        if let start = from {
            guard start < self.count else {
                return ""
            }
        }
        if let end = to {
            guard end >= 0 else {
                return ""
            }
        }
        if let start = from, let end = to {
            guard end - start >= 0 else {
                return ""
            }
        }
        let startIndex: String.Index
        if let start = from, start >= 0 {
            startIndex = self.index(self.startIndex, offsetBy: start)
        } else {
            startIndex = self.startIndex
        }
        let endIndex: String.Index
        if let end = to, end >= 0, end < self.count {
            endIndex = self.index(self.startIndex, offsetBy: end + 1)
        } else {
            endIndex = self.endIndex
        }
        return String(self[startIndex ..< endIndex])
    }
    
    // MARK: 格式化的 url
    /// - Returns: 格式化的 url
    func hw_encoding() -> String {
        let url = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        return url ?? ""
    }
    // MARK: 字符串裁剪 (key=nil 默认为",")
    /// 字符串裁剪 (key=nil 默认为",")
    func hw_tailoring(_ key: String? = nil) -> NSArray {
        let array = self.components(separatedBy:(key?.count ?? 0) > 0 ? "," : key!) as NSArray
        let newArray = NSMutableArray()
        for i in 0..<array.count {
            let str = array[i] as! String
            if !str.isEmpty {
                newArray.add(str)
            }
        }
        return newArray
    }

    // MARK: 时间搓字符串转时间
    /// 时间搓字符串转时间
    func hw_toDate(_ dateFormat:String? = nil) -> String{
        /* 例
         let timeStamp = "1463637809"
         HWPrint(timeStamp.hw_stringToDate(dateFormat: "yyyy年MM月dd日 HH:mm:ss"))
         */
        //格式话输出
        if self.isEmpty { return "" }
        let format = DateFormatter.init()
        format.dateStyle = .medium
        format.timeStyle = .short
        if dateFormat == nil {
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }else{
            format.dateFormat = dateFormat
        }
        let date = format.date(from: self)
        return String(date!.timeIntervalSince1970)
//        let timeStamp = Int(self)
//        //转换为时间
//        let timeInterval:TimeInterval = TimeInterval(timeStamp!/1000)
//        let date = Date(timeIntervalSince1970: timeInterval)
//        let dformatter = DateFormatter()
//        dformatter.dateFormat = dateFormat // "yyyy年MM月dd日 HH:mm:ss"
//        return dformatter.string(from: date)
    }
    // MARK: 将字符转为整数值
    /// 将字符转为整数值
    func hw_toASCII() -> Int {
        var number:Int = 0
        for code in self.unicodeScalars {
            number = Int(code.value)
        }
        return Int(number)
    }
    // MARK: json字符串数组转数组
    /// json字符串数组转数组
    ///
    /// - Returns:
    func hw_jsonToArray() -> [String] {
        if let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            if let array = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String] {
                return array ?? [String]()
            } else {
                return [String]()
            }
        } else {
            return [String]()
        }
    }
    // MARK: html文本转富文本
    /// html文本转富文本
    ///
    /// - Returns: 富文本
    func hw_HTMLToAttributedString() -> NSAttributedString {
        do{
            guard let data = self.data(using: String.Encoding.unicode, allowLossyConversion: true) else {
                return NSMutableAttributedString(string: self)
            }
            var options = [NSAttributedString.DocumentReadingOptionKey : Any]()
            options[NSAttributedString.DocumentReadingOptionKey.documentType] = NSAttributedString.DocumentType.html
            let attrStr = try NSAttributedString(data: data, options: options, documentAttributes: nil)
            return attrStr
        }catch let error as NSError {
            print(error.localizedDescription)
            return NSMutableAttributedString(string: self)
        }
    }
}
extension String {
    // MARK: 获取文字尺寸
    /// 获取文字尺寸
    ///
    /// - Parameters:
    ///   - rectSize: 容器的尺寸
    ///   - font: 字体大小
    /// - Returns: 尺寸
    func hw_getSize(rectSize: CGSize,font: CGFloat) -> CGSize {
        let str = self as NSString
        let rect = str.boundingRect(with: rectSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: font)], context: nil)
        return rect.size
    }
    
    /// 获取文字高度
    ///
    /// - Parameters:
    ///   - width: 最大宽带
    ///   - font: 字体大小
    /// - Returns: 文字高度
    func hw_getHeight(width: CGFloat, font: CGFloat) -> CGFloat {
        let rect = self.boundingRect(with: CGSize.init(width: width, height: 100000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: font)], context: nil)
        return rect.size.height
    }
    
    /// 获取文字宽度
    ///
    /// - Parameters:
    ///   - height: 最大高度
    ///   - font: 字体大小
    /// - Returns: 文字宽度
    func hw_getWidth(height: CGFloat, font: CGFloat) -> CGFloat {
        let rect = self.boundingRect(with: CGSize.init(width: 100000, height: height), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: font)], context: nil)
        return rect.size.width
    }
}

extension String {
    // MARK: - 返回子字符串在此字符串中的索引
    /// 返回子字符串在此字符串中的索引 backwards = nil/false(第一次出现) 反正最后出现
    ///
    /// - Parameters:
    ///   - sub: 要查询的字符串
    ///   - backwards: = nil/false(第一次出现) 反正最后出现
    /// - Returns: 位置
    func hw_subAtIndex(sub:String, backwards:Bool? = nil) -> Int {
        var pos = -1
        if backwards == nil {
            if let range = range(of:sub, options: .literal) {
                if !range.isEmpty {
                    pos = self.distance(from:startIndex, to:range.lowerBound)
                }
            }
        } else {
            if let range = range(of:sub, options: backwards! == true ? .backwards : .literal ) {
                if !range.isEmpty {
                    pos = self.distance(from:startIndex, to:range.lowerBound)
                }
            }
        }
        return pos
    }
}

// MARK: - 手机号格式化隐藏中间4位
extension String {
    /// 手机号格式化隐藏中间4位 注意:必须要11未不然就直接返回原本
    func hw_phoneFormatting() -> String {
        if self.count != 11 { return self }
        let top =  self.hw_substring(from: 0, to: 2)
        let buttom = self.hw_substring(from: self.count-4)
        return top + "****" + buttom
    }
}

extension String {
    /// 获取显示时间
    func hw_getShowTime(_ dateFormat:String? = nil) -> String {
        var result:String = ""
        if self.count == 0 {
            return self
        }
        let datefmatter = DateFormatter()
        if dateFormat?.count == 0 {
            datefmatter.dateFormat = dateFormat
        } else {
            datefmatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        }
        
        let currentDate = Date()
        let currenttimeInterval:TimeInterval = currentDate.timeIntervalSince1970
        
        let date = datefmatter.date(from: self) // 传入时间
        let timeInterval:TimeInterval = date!.timeIntervalSince1970
        
        let num = (currenttimeInterval-timeInterval)/3600
        if num < 24 { // 今天
            result = Int(timeInterval).hw_stringToDate(dateFormat: "HH:mm")
        } else if num < 2*24 { // 昨天
            result = "昨天" + Int(timeInterval).hw_stringToDate(dateFormat: "HH:mm")
        } else if num < 3*24 { // 前天
            result = "前天" + Int(timeInterval).hw_stringToDate(dateFormat: "HH:mm")
        } else if num < 365*24 { // 今年
            result = Int(timeInterval).hw_stringToDate(dateFormat: "MM-dd HH:mm")
        } else {
            result = Int(timeInterval).hw_stringToDate(dateFormat: "yyyy-MM-dd HH:mm")
        }
        return result
    }
}
// MARK: - 获取首字母
extension String {
    /// 获取首字母
    func hw_getFirstLetter() -> String {
        //转变成可变字符串
        let mutableString = NSMutableString.init(string: self)
        //将中文转换成带声调的拼音
        CFStringTransform(mutableString as CFMutableString, nil, kCFStringTransformToLatin, false)
        //去掉声调
        let pinyinString = mutableString.folding(options: String.CompareOptions.diacriticInsensitive, locale: NSLocale.current)
        //将拼音首字母换成大写
        let strPinYin = polyphoneStringHandle(nameString: self, pinyinString: pinyinString).uppercased()
        //截取大写首字母
        let firstString = strPinYin.substring(to: strPinYin.index(strPinYin.startIndex, offsetBy: 1))
        //判断首字母是否为大写
        let regexA = "^[A-Z]$"
        let predA = NSPredicate.init(format: "SELF MATCHES %@", regexA)
        return predA.evaluate(with: firstString) ? firstString : "#"
    }
    
    //多音字处理，根据需要添自行加
    func polyphoneStringHandle(nameString: String, pinyinString: String) -> String {
        if nameString.hasPrefix("长") {return "chang"}
        if nameString.hasPrefix("沈") {return "shen"}
        if nameString.hasPrefix("厦") {return "xia"}
        if nameString.hasPrefix("地") {return "di"}
        if nameString.hasPrefix("重") {return "chong"}
        return pinyinString
    }
}
// MARK: - 获取位置
extension String {
    func hw_getNsRange(_ sub:String) -> NSRange {
        if let range = self.range(of: sub)  {// Range 类型
            return NSRange(range, in: self)
        }
        return NSRange.init(location: 0, length: 0)
    }
}
// MARK: - 类型转换
extension String {
    public func hw_cgFloat(locale: Locale = .current) -> CGFloat {
        if self.count == 0 {
            return 0
        }
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        if let float = formatter.number(from: self) as? CGFloat {
            return float
        } else {
            return 0
        }
    }
    public var hw_int: Int? {
        return Int(self)
    }
    public func hw_float(locale: Locale = .current) -> Float {
        if self.count == 0 {
            return 0
        }
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        if let float = formatter.number(from: self)?.floatValue {
            return float
        } else {
            return 0
        }
    }
}
