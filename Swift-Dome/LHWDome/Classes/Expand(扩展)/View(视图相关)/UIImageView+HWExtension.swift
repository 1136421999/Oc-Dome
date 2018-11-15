//
//  UIImageView+HWExtension.swift
//  BBCShop
//
//  Created by Hanwen on 2018/1/17.
//  Copyright © 2018年 SK丿希望. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView {
    
    /// 网络加载图片
    func hw_setImage(urlString:String?, placeholderString:String?){
        var newPlaceholderString = ""
        if placeholderString == nil || (placeholderString?.isEmpty)! { // 占位图片为空 或者空字符串是 添加备用
            newPlaceholderString = "占位图片"
        } else { // 赋值传入的
            newPlaceholderString = placeholderString!
        }
        guard let urlStr = urlString else { // urlString为空是直接返回占位图片
            self.image = UIImage(named: newPlaceholderString)
            return
        }
        let url = URL(string: urlStr)
        if url == nil { // url为空是直接返回占位图片
            self.image = UIImage(named: newPlaceholderString)
            return
        }
        // 调用kf加载图片
        self.kf.setImage(with: url, placeholder: UIImage(named: newPlaceholderString), options: nil, progressBlock: nil, completionHandler: {[weak self] (image, error,_,_) in
            if error != nil { // 报错是使用占位图片
                self?.image = UIImage(named: newPlaceholderString )
            }
        })
    }
    /// 修改模式以最小边为参照 多余的裁剪
    func hw_setModeScaleAspectFill() {
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
    }
    // 关联 SB 和 XIB 设置图片圆角
//    public func circleImage() {
//        /// 建立上下文
//        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
//        /// 获取当前上下文
//        let ctx = UIGraphicsGetCurrentContext()
//        /// 添加一个圆，并裁剪
//        ctx?.addEllipse(in: self.bounds)
//        ctx?.clip()
//        /// 绘制图像
//        self.draw(self.bounds)
//        /// 获取绘制的图像
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        /// 关闭上下文
//        UIGraphicsEndImageContext()
//        DispatchQueue.global().async {
//            self.image = image
//        }
//    }
    // 关联 SB 和 XIB
//    @IBInspectable public var hw_circleImage: Bool {
//        get {
//            return false
//        }
//        set {
////            hw_circleImage = newValue
//            if newValue {
//                //                 建立上下文
//                self.addRounded()
//            }
//        }
//    }
}
