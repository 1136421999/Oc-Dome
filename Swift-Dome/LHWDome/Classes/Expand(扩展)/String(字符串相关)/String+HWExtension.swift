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
    // MARK: - 字符串截取
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
    
    // MARK: - 获取文字尺寸
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
    // MARK: - 字符串转数组
    /// 字符串转数组
    // 例:"qwert".hw_toArray() -> ["q","w","e","r","t"]
    func hw_toArray() -> [String] {
        let num = count
        if !(num > 0) { return [""] }
        var arr: [String] = []
        for i in 0..<num {
            let tempStr: String = self[self.index(self.startIndex, offsetBy: i)].description
            arr.append(tempStr)
        }
        return arr
    }
    
    // MARK: - 格式化的 url
    /// - Returns: 格式化的 url
    func hw_encoding() -> String {
        let url = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        return url ?? ""
    }
    // MARK: - 字符串裁剪 (key=nil 默认为",")
    /// 字符串裁剪 (key=nil 默认为",")
    func hw_tailoring(_ key: String? = nil) -> NSArray {
        let array = self.components(separatedBy:key == nil ? "," : key!) as NSArray
        let newArray = NSMutableArray()
        for i in 0..<array.count {
            let str = array[i] as! String
            if !str.isEmpty {
                newArray.add(str)
            }
        }
        return newArray
    }

    // MARK: - 时间搓字符串转时间
    /// 时间搓字符串转时间
    func hw_toDate(dateFormat:String) -> String{
        /* 例
         let timeStamp = "1463637809"
         HWPrint(timeStamp.hw_stringToDate(dateFormat: "yyyy年MM月dd日 HH:mm:ss"))
         */
        //格式话输出
        if self.isEmpty { return "" }
        let timeStamp = Int(self)
        //转换为时间
        let timeInterval:TimeInterval = TimeInterval(timeStamp!/1000)
        let date = Date(timeIntervalSince1970: timeInterval)
        let dformatter = DateFormatter()
        dformatter.dateFormat = dateFormat // "yyyy年MM月dd日 HH:mm:ss"
        return dformatter.string(from: date)
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
