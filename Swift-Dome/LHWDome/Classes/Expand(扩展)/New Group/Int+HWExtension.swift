//
//  Int+HWExtension.swift
//  personal
//
//  Created by 李含文 on 2019/5/28.
//  Copyright © 2019年 suzao. All rights reserved.
//

import Foundation

/// bytes转Int
func hw_getInt(_ array:[UInt8]) -> Int {
    var value : UInt32 = 0
    let data = NSData(bytes: array, length: array.count)
    data.getBytes(&value, length: array.count)
    value = UInt32(bigEndian: value)
    return Int(value)
}

extension Int {
    // MARK:- 转成 2位byte
    func hw_to2Bytes() -> [UInt8] {
        let UInt = UInt16.init(Double.init(self))
        return [UInt8(truncatingIfNeeded: UInt >> 8),UInt8(truncatingIfNeeded: UInt)]
    }
    // MARK:- 转成 4字节的bytes
    func hw_to4Bytes() -> [UInt8] {
        let UInt = UInt32.init(Double.init(self))
        return [UInt8(truncatingIfNeeded: UInt >> 24),
                UInt8(truncatingIfNeeded: UInt >> 16),
                UInt8(truncatingIfNeeded: UInt >> 8),
                UInt8(truncatingIfNeeded: UInt)]
    }
    // MARK:- 转成 8位 bytes
    func intToEightBytes() -> [UInt8] {
        let UInt = UInt64.init(Double.init(self))
        return [UInt8(truncatingIfNeeded: UInt >> 56),
            UInt8(truncatingIfNeeded: UInt >> 48),
            UInt8(truncatingIfNeeded: UInt >> 40),
            UInt8(truncatingIfNeeded: UInt >> 32),
            UInt8(truncatingIfNeeded: UInt >> 24),
            UInt8(truncatingIfNeeded: UInt >> 16),
            UInt8(truncatingIfNeeded: UInt >> 8),
            UInt8(truncatingIfNeeded: UInt)]
    }
    
    func hw_stringToDate(dateFormat:String) -> String{
        /* 例
         let timeStamp = "1463637809"
         HWPrint(timeStamp.hw_stringToDate(dateFormat: "yyyy年MM月dd日 HH:mm:ss"))
         */
        //格式话输出
        let timeStamp = Int(self)
        //        print("时间戳：\(String(describing: timeStamp))")
        //转换为时间
        var timeInterval:TimeInterval?
        if self > 1000000000 {
            timeInterval = TimeInterval(timeStamp/1000)
        } else {
            timeInterval = TimeInterval(timeStamp)
        }
        let date = Date(timeIntervalSince1970: timeInterval ?? 0)
        let dformatter = DateFormatter()
        dformatter.dateFormat = dateFormat // "yyyy年MM月dd日 HH:mm:ss"
        return dformatter.string(from: date)
    }
}

