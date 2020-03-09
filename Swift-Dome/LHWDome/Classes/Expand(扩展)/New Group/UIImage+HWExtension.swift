//
//  UIImage+HWExtension.swift
//  单选相册
//
//  Created by Hanwen on 2018/2/8.
//  Copyright © 2018年 SK丿希望. All rights reserved.
//

import UIKit

extension UIImage {
    /// 修复图片旋转
    func hw_fixOrientation() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
        var transform = CGAffineTransform.identity
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: .pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -.pi / 2)
            break
        default:
            break
        }
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1)
            break
        default:
            break
        }
        let ctx = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: self.cgImage!.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(self.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.height), height: CGFloat(size.width)))
            break
        default:
            ctx?.draw(self.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.width), height: CGFloat(size.height)))
            break
        }
        let cgimg: CGImage = (ctx?.makeImage())!
        let img = UIImage(cgImage: cgimg)
        return img
    }
}

extension UIImage {
    /// 裁剪图片
    func hw_cropImage(rect: CGRect) -> UIImage {
        let sourceImageRef = self.cgImage
        let newImageRef = sourceImageRef!.cropping(to: rect)
        let newImage = UIImage(cgImage: newImageRef!)
        return newImage
    }
    /// 异步绘制图像
    func hw_asyncDrawImage(rect: CGRect,
                           isCorner: Bool = false,
                           backColor: UIColor? = UIColor.white,
                           finished: @escaping (_ image: UIImage)->()) {
        // 异步绘制图像，可以在子线程进行，因为没有更新 UI
        DispatchQueue.global().async {
            // 如果指定了背景颜色，就不透明
            UIGraphicsBeginImageContextWithOptions(rect.size, backColor != nil, 1)
            let rect = rect
            if backColor != nil{
                // 设置填充颜色
                backColor?.setFill()
                UIRectFill(rect)
            }
            // 设置圆角 - 使用路径裁切，注意：写设置裁切路径，再绘制图像
            if isCorner {
                let path = UIBezierPath(ovalIn: rect)
                // 添加裁切路径 - 后续的绘制，都会被此路径裁切掉
                path.addClip()
            }
            // 绘制图像
            self.draw(in: rect)
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            // 主线程更新 UI，提示：有的时候异步也能更新 UI，但是会非常慢！
            DispatchQueue.main.async {
                finished(result!)
            }
        }
    }
}
extension UIImage {
    /// 保护四边拉伸图片
    func hw_protectTensile() -> UIImage {
        // 设置端盖的值
        let top = self.size.height * 0.5
        let left = self.size.width * 0.5
        let bottom = self.size.height * 0.5
        let right = self.size.width * 0.5
        // 设置端盖的值
        let edgeInsets = UIEdgeInsetsMake(top, left, bottom, right)
        // 设置拉伸的模式
        let mode = UIImageResizingMode.stretch
        // 拉伸图片
        return resizableImage(withCapInsets: edgeInsets, resizingMode: mode)
    }
    // 中心点拉伸保留四周
    func hw_stretchable() -> UIImage {
        return self.stretchableImage(withLeftCapWidth: Int(self.size.width*0.5), topCapHeight: Int(self.size.width*0.5))
    }
    /// 根据颜色生成图片
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - size:
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
