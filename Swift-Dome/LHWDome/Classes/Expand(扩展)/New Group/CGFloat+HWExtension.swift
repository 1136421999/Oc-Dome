//
//  CGFloat+HWExtension.swift
//  LHWDome
//
//  Created by 李含文 on 2019/7/12.
//  Copyright © 2019年 李含文. All rights reserved.
//

import Foundation

/// 小数点后如果只是0，显示整数，如果不是，显示原来的值
extension CGFloat {
    /// 清除小数点后多余的0
    var hw_cleanZero : CGFloat {
        return truncatingRemainder(dividingBy: 1)
    }
}

extension Float {
    /// 清除小数点后多余的0
    var hw_cleanZero : Float {
        return truncatingRemainder(dividingBy: 1)
    }
}

extension Double {
    /// 清除小数点后多余的0
    var hw_cleanZero : Double {
        /// Swift中允许浮点型取余，但是在Swift3之后取余运算符%不能应用于浮点数运算，需要使用public func truncatingRemainder(dividingBy other: Double) -> Double方法来计算浮点型取余。
        return truncatingRemainder(dividingBy: 1)
    }
}
