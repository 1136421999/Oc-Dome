//
//  HWHUDManage.swift
//  YMWS
//
//  Created by 李含文 on 2018/7/28.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

/*
 HUD显示时默认是屏蔽事件的
 如果想取消在调用的时候统一设置(HWHUDManage.isReceiveEvent = true)即可
 */
import Foundation

private let hudreserved: CGFloat = 15 // 预留空间
private let hudmaxWidth: CGFloat = (UIScreen.main.bounds.size.width - 100) // 文字最大宽度
private let hudiconWH: CGFloat = 36 // 图片大小
private let hudlabelSize: CGFloat = 13 // 文本大小
private let hudlineSpacing: CGFloat = 3 // 行间距

class HWHUDManage: NSObject {
    // MARK: - HUD相关
    static let instance: HWHUDManage = HWHUDManage()
    /// 是否接收事件 默认不接收
    static var isReceiveEvent = false
    class var sharedHUD: HWHUDManage {
        return instance
    }
    
    /// 加载HUD
    ///
    /// - Parameter name: 提示语
    func hw_showLoadingHUD(name: String?,time: TimeInterval? = nil) {
        if time == nil {
            HWProgressHUD.show(.loading, text: name ?? "", time: 60, completion: nil)
        } else {
            HWProgressHUD.show(.loading, text: name ?? "", time: time, completion: nil)
        }
    }
    
    /// 只显示文字
    func hw_showtitleHUD(name: String?) {
        hw_showtitleHUD(name: name ?? "", delay: 1)
    }
    
    /// 只显示文字
    ///
    /// - Parameters:
    ///   - name: 提示语
    ///   - delay: 延迟时间
    func hw_showtitleHUD(name: String? ,delay: TimeInterval) {
         HWProgressHUD.show(.none, text: name ?? "", time: delay, completion: nil)
    }
    
    /// 加载HUD 提示语为(正在加载)
    func hw_showLoadingHUD() {
        self.hw_showLoadingHUD(name: "正在加载")
    }
    
    /// 隐藏HUD
    func hw_dismissHUD(){
        HWProgressHUD.dismiss()
    }
    
    /// 成功提示
    func hw_showSuccessHUD(name: String) {
        HWProgressHUD.show(.success, text: name, time: 1, completion: nil)
    }
    
    /// 失败提示
    func hw_showErrorHUD(name: String) {
        HWProgressHUD.show(.error, text: name, time: 1, completion: nil)
    }
    
//    deinit {
//        #if DEBUG
//        print("\((#file as NSString).lastPathComponent)[\(#line)], \(#function): \("HUD释放")")
//        #endif
//    }
}

extension UIViewController {
    /// HUD管理者 使用 HUDManage?.hw_showtitleHUD(name: "HUD")
    @IBInspectable var HUDManage: HWHUDManage? {
        get {
            return HWHUDManage.sharedHUD
        }
        set {}
    }
}
extension UIView {
    /// HUD管理者 使用 HUDManage?.hw_showtitleHUD(name: "HUD")
    @IBInspectable var HUDManage: HWHUDManage? {
        get {
            return HWHUDManage.sharedHUD
        }
        set {}
    }
}

public typealias HUDCompletedBlock = () -> Void
public enum HWProgressHUDType {
    case loading
    case success
    case error
    case info
    case none
}

public extension HWProgressHUD {
    public class func show(_ type: HWProgressHUDType, text: String, time: TimeInterval? = nil, completion: HUDCompletedBlock? = nil) {
        dismiss()
        instance.registerDeviceOrientationNotification()
        var isNone: Bool = false
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        let mainView = UIView()
        mainView.layer.cornerRadius = 10
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.7)
        
        var image = UIImage()
        var headView = UIView()
        switch type { /// 添加图片
        case .success:
            image = imageOfCheckmark
        case .error:
            image = imageOfCross
        case .info:
            image = imageOfInfo
        default:
            break
        }
        
        switch type { // 添加 headView
        case .loading:
            headView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            (headView as! UIActivityIndicatorView).startAnimating()
            headView.translatesAutoresizingMaskIntoConstraints = false
            mainView.addSubview(headView)
        case .success: // 加了fallthrough后，会直接运行【紧跟的后一个】
            fallthrough
        case .error:
            fallthrough
        case .info:
            headView = UIImageView(image: image)
            headView.translatesAutoresizingMaskIntoConstraints = false
            mainView.addSubview(headView)
        case .none:
            isNone = true
        }
        
        // label
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: hudlabelSize)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        let arr = NSMutableAttributedString(string: text).hud_addLineSpacing(hudlineSpacing)
        label.attributedText = arr
        
        var height: CGFloat = text.count > 0 ? arr.hud_getHeight(hudmaxWidth) : 0 // 因为加了行间距 高度不可能=0 (所有用是否有内容来判断)
        height = height+height/label.font.pointSize*hudlineSpacing
        var width = arr.hud_getWidth(CGFloat(MAXFLOAT), hudmaxWidth)
        if !isNone { // 有图标
            width = height > 0 ? width : hudiconWH
            height = height > 0 ? height+hudiconWH+hudreserved : hudiconWH
        }
        label.textAlignment = NSTextAlignment.center
        mainView.addSubview(label)
    
        if HWHUDManage.isReceiveEvent == false { // 不接受事件
            window.frame = UIScreen.main.bounds
            mainView.frame = CGRect(x: (UIScreen.main.bounds.size.width-(width+hudreserved*3))/2, y: (UIScreen.main.bounds.size.height-(height+hudreserved*2))/2, width: width+hudreserved*3, height: height+hudreserved*2)
        } else {
            let superFrame = CGRect(x: 0, y: 0, width: width+hudreserved*3, height: height+hudreserved*2)
            window.frame = superFrame
            mainView.frame = superFrame
        }
        
        // image
        if !isNone { // 有图标
            mainView.addConstraint(NSLayoutConstraint(item: headView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.lessThanOrEqual, toItem: mainView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: hudreserved))
            mainView.addConstraint(NSLayoutConstraint(item: headView, attribute: .centerX, relatedBy: .equal, toItem: mainView, attribute: .centerX, multiplier: 1.0, constant: 0) )
            mainView.addConstraint(NSLayoutConstraint(item: headView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: hudiconWH))
            mainView.addConstraint(NSLayoutConstraint(item: headView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: hudiconWH))
        }
        // label
        if !isNone { // 如果有图标 + 图标高度 图标和文字间距15
           let labelTop = hudreserved + hudiconWH + hudreserved
            mainView.addConstraint(NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.lessThanOrEqual, toItem: mainView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: labelTop))
        } else { // 没有图标 直接居中
            mainView.addConstraint(NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.lessThanOrEqual, toItem: mainView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
        }
        mainView.addConstraint( NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: mainView, attribute: .centerX, multiplier: 1.0, constant: 0) )
        mainView.addConstraint( NSLayoutConstraint(item: label, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .width, multiplier: 1.0, constant: hudmaxWidth))
        mainView.addConstraint( NSLayoutConstraint(item: label, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0) )
        window.windowLevel = UIWindowLevelAlert
        window.center = getCenter()
        window.isHidden = false
        window.addSubview(mainView)
        windowsTemp.append(window)
        if time != 0 {
            delayDismiss(time, completion: completion)
        }
    }
    
    public class func dismiss() {
        timer?.cancel()
        timer = nil
        instance.removeDeviceOrientationNotification()
        if let currentwindow = windowsTemp.last {
            for (_, view) in currentwindow.subviews.enumerated() {
                view.removeFromSuperview()
            }
        }
        windowsTemp.removeAll(keepingCapacity: false)
    }
}


open class HWProgressHUD: NSObject {
    fileprivate static var windowsTemp = [UIWindow]()
    fileprivate static var timer: DispatchSourceTimer?
    fileprivate static let instance = HWProgressHUD()
    private struct Cache {
        static var imageOfCheckmark: UIImage?
        static var imageOfCross: UIImage?
        static var imageOfInfo: UIImage?
    }
    
    // center
    fileprivate class func getCenter() -> CGPoint {
        return CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
    }
    
    // delay dismiss
    fileprivate class func delayDismiss(_ time: TimeInterval?, completion: HUDCompletedBlock?) {
        guard let time = time else { return }
        guard time > 0 else { return }
        var timeout = time
        timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: 0),
                                               queue: DispatchQueue.main)// as! DispatchSource
        timer!.schedule(wallDeadline: .now(), repeating: .seconds(1))
        timer!.setEventHandler {
            if timeout <= 0 {
                DispatchQueue.main.async {
                    dismiss()
                    completion?()
                }
            } else {
                timeout -= 1
            }
        }
        timer!.resume()
    }
    
    // register notification
    fileprivate func registerDeviceOrientationNotification() {
        NotificationCenter.default.addObserver(HWProgressHUD.instance, selector: #selector(HWProgressHUD.transformWindow(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    // remove notification
    fileprivate func removeDeviceOrientationNotification() {
        NotificationCenter.default.removeObserver(HWProgressHUD.instance)
    }
    
    // transform
    @objc fileprivate func transformWindow(_ notification: Notification) {
        var rotation: CGFloat = 0
        switch UIDevice.current.orientation {
        case .portrait:
            rotation = 0
        case .portraitUpsideDown:
            rotation = .pi
        case .landscapeLeft:
            rotation = .pi * 0.5
        case .landscapeRight:
            rotation = CGFloat(.pi + (.pi * 0.5))
        default:
            break
        }
        HWProgressHUD.windowsTemp.forEach {
            $0.center = HWProgressHUD.getCenter()
            $0.transform = CGAffineTransform(rotationAngle: rotation)
        }
    }
    
    // draw
    // MARK: - 绘画
    private class func draw(_ type: HWProgressHUDType) {
        let checkmarkShapePath = UIBezierPath()
        switch type {
        case .success: // draw checkmark
            checkmarkShapePath.move(to: CGPoint(x: 5, y: 21))
            checkmarkShapePath.addLine(to: CGPoint(x: 16, y: 32))
            checkmarkShapePath.addLine(to: CGPoint(x: 35, y:11))
            checkmarkShapePath.move(to: CGPoint(x: 5, y: 21))
            checkmarkShapePath.close()
        case .error: // draw X
            checkmarkShapePath.move(to: CGPoint(x: 7, y: 10))
            checkmarkShapePath.addLine(to: CGPoint(x: 29, y: 31))
            checkmarkShapePath.move(to: CGPoint(x: 7, y: 31))
            checkmarkShapePath.addLine(to: CGPoint(x: 29, y: 10))
            checkmarkShapePath.move(to: CGPoint(x: 7, y: 10))
            checkmarkShapePath.close()
        case .info:
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 10))
            checkmarkShapePath.addLine(to: CGPoint(x: 18, y: 26))
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 10))
            checkmarkShapePath.close()
            UIColor.white.setStroke()
            checkmarkShapePath.stroke()
            let checkmarkShapePath = UIBezierPath()
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 31))
            checkmarkShapePath.addArc(withCenter: CGPoint(x: 18, y: 31), radius: 1, startAngle: 0, endAngle: .pi * 2, clockwise: true)
            checkmarkShapePath.close()
            UIColor.white.setFill()
            checkmarkShapePath.fill()
        default: break
        }
        UIColor.white.setStroke()
        checkmarkShapePath.stroke()
    }
    // MARK: - 画勾
    fileprivate class var imageOfCheckmark: UIImage {
        if (Cache.imageOfCheckmark != nil) {
            return Cache.imageOfCheckmark!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        HWProgressHUD.draw(.success)
        Cache.imageOfCheckmark = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCheckmark!
    }
    // MARK: - 画X
    fileprivate class var imageOfCross: UIImage {
        if (Cache.imageOfCross != nil) {
            return Cache.imageOfCross!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        HWProgressHUD.draw(.error)
        Cache.imageOfCross = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCross!
    }
    // MARK: - 画!
    fileprivate class var imageOfInfo: UIImage {
        if (Cache.imageOfInfo != nil) {
            return Cache.imageOfInfo!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        HWProgressHUD.draw(.info)
        Cache.imageOfInfo = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfInfo!
    }
}
public extension NSMutableAttributedString {
    /// 获取范围
    func hud_allRange() -> NSRange {
        return NSMakeRange(0,length)
    }
    /// 添加行间距
    @discardableResult
    func hud_addLineSpacing(_ lineSpacing:CGFloat) -> NSMutableAttributedString {
        let paragraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing //大小调整
        self.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: hud_allRange())
        return self
    }
    /// 计算字符串的高度
    @discardableResult
    func hud_getHeight(_ width : CGFloat) -> CGFloat {
        let rect = self.boundingRect(with: CGSize.init(width: width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        return rect.size.height
    }
    /// 计算富文本的宽度
    ///
    /// - Parameter height: 最大高度
    /// - Returns: 宽度
    @discardableResult
    func hud_getWidth(_ height: CGFloat, _ with: CGFloat = CGFloat(MAXFLOAT)) -> CGFloat {
        let rect = self.boundingRect(with: CGSize.init(width: with, height: height), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        return rect.size.width
    }
}
