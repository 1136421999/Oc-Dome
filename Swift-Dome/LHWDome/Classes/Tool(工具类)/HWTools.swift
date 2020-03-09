//
//  HWTools.swift
//  SwiftTest
//
//  Created by Hanwen on 2018/1/3.
//  Copyright © 2018年 SK丿希望. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit


// MARK: - 打印相关
func HWPrint<T>(_ message: T, // 添加_ 可以隐藏参数提示
    file: String = #file, // 文件名
    method: String = #function, // 方法名
    line: Int = #line) { // 行数
    #if DEBUG
    print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}

/// 是否是x
let isiPhoneX = (UIApplication.shared.statusBarFrame.height > 20 ? true : false)
/// 屏幕高
let HW_ScreenH = UIScreen.main.bounds.size.height
/// 屏幕宽
let HW_ScreenW = UIScreen.main.bounds.size.width
/// 获取导航栏高度
let hw_navigationH : CGFloat = (isiPhoneX ? 88 : 64)
/// 获取tabBar高度
let hw_tabBarH : CGFloat = (isiPhoneX ? 83 : 49)
/// 获取安全高度
let hw_safetyH : CGFloat = (isiPhoneX ? 34 : 0)
/// 屏幕比例高度
func HW_ProportionH(height:CGFloat) -> CGFloat {
    return HW_ScreenW*height/375
}


// MARK: - 颜色相关
func HWColor(r:CGFloat, g:CGFloat, b:CGFloat) -> UIColor {
    return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
}
/// 未选中颜色
func HWUncheckColor() -> UIColor {
    return "BEBEBE".hw_hexColor()
}
func HWBGColor() -> UIColor { // 背景颜色
    return "F3F3F3".hw_hexColor()
}
func HWLineColor() -> UIColor { // 线条颜色
    return "E9E9E9".hw_hexColor()
}
/// 导航栏颜色
func HWNavigationBarColor() -> UIColor {
    return "C59758".hw_hexColor()
}
func HWGradientColor() -> UIColor { // 渐变
    let bgColor = UIColor.hw_color(.LeftToRight, "418CFF", "4AA8FF")
    return bgColor
}
/// App主要颜色
func HWMainColor() -> UIColor {
    return "C59758".hw_hexColor()
}

func HWFontLowColor() -> UIColor { // 常用字体颜色 较深
    return HWColor(r: 53, g: 53, b: 53)
}
func HWFontMidColor() -> UIColor { // 常用字体颜色 较深
    return HWColor(r: 99, g: 99, b: 99)
}
func HWFontHighColor() -> UIColor { // 常用字体颜色 较浅
    return HWColor(r: 163, g: 163, b: 163)
}

// MARK: - 解决图片渲染问题
func hw_Image(named:String) -> UIImage {
    guard let image : UIImage = UIImage.init(named: named)?.withRenderingMode(.alwaysOriginal) else{
        return  UIImage()
    }
    return image
}


/// 快速添加底部的蓝色view 使用方法addBgView(view: self.view)
func addBgView(view : UIView){
    let bgview = UIView.init(frame: CGRect.init(x: 0, y: 0, width: HW_ScreenW, height: 90))
    bgview.backgroundColor = "29D8A5".hw_hexColor()
    view.addSubview(bgview)
    view.sendSubview(toBack: bgview) // 放到最底层
}
func addBgView(view : UIView, height:CGFloat)-> UIView{
    let bgview = UIView.init(frame: CGRect.init(x: 0, y: 0, width: HW_ScreenW, height: height))
    bgview.backgroundColor = HWNavigationBarColor()
    view.addSubview(bgview)
    view.sendSubview(toBack: bgview) // 放到最底层
    //        self.tableVIew.bringSubview(toFront: view) // 将tableVIew放到最顶层
    return bgview
}
/// 快速添加底部的view view:要添加在哪个view上 bgColoc:背景颜色 height:高度
func addBgView(view : UIView, bgColoc : UIColor, height: CGFloat){
    let bgview = UIView.init(frame: CGRect.init(x: 0, y: 0, width: HW_ScreenW, height: height))
    bgview.backgroundColor = bgColoc
    view.addSubview(bgview)
    view.sendSubview(toBack: bgview) // 放到最底层
}

/// 视频播放
//https://v.qq.com/x/page/c01487zqu0p.html
func reviewVideo(_ videoURLString: String) {
    //定义一个视频播放器，通过本地文件路径初始化
    let player = AVPlayer(url: NSURL.init(string: videoURLString)! as URL)
    let playerViewController = AVPlayerViewController()
    playerViewController.player = player
    UIApplication.shared.keyWindow?.rootViewController?.present(playerViewController, animated: true) {
        playerViewController.player!.play()
    }
}

/// 存储代理cid
//func hw_setDLCid(_ cid: String) {
//    let defaults = UserDefaults.standard
//    defaults.set(cid, forKey: "hw_getDLCid")
//    defaults.synchronize()
//}
/// 获取代理中的cid
//func hw_getDLCid()->String {
//    let defaults = UserDefaults.standard
//    return defaults.string(forKey: "hw_getDLCid") ?? ""
//}
/// 获取用户cid
//func hw_getCid()->String {
//    if UserTool.userCheckLogin() {
//        return UserInfo.sharedInstance.user?.cid ?? ""
//    }
//    return ""
////    return "1028"
//}

//func hw_getUser()->User? {
//    if UserTool.userCheckLogin() {
//        return UserInfo.sharedInstance.user ?? nil
//    }
//    return nil
//}

/// 拨打电话
func callPhone(_ phone: String) {
    if phone.isEmpty {
//        HWHUDManage.sharedHUD.hw_showtitleHUD(name: "电话号码异常")
    } else {
        UIApplication.shared.openURL(NSURL(string :"tel://"+phone)! as URL)
    }
}



func  hw_share(title:String?, image:UIImage?, urlString: String?){
    let image = image ?? UIImage.init(named: "占位图片")
    //一个字符串
    let shareString = title ?? "妙吉鸟"
    //一个URL
    let shareURL = NSURL(string: urlString ?? "")
    //初始化一个UIActivity
    let activity = UIActivity()
    let activities = [activity]
    let activityItems = [image as! UIImage, shareString, shareURL] as [Any]
    let activityVC = UIActivityViewController.init(activityItems: activityItems, applicationActivities: activities)
    activityVC.excludedActivityTypes = [UIActivityType.postToFacebook,UIActivityType.airDrop]
    UIApplication.shared.keyWindow?.rootViewController?.present(activityVC, animated: true, completion: nil)
    let completionHandler : UIActivityViewControllerCompletionWithItemsHandler = {( activityType, completed,returnedItems, activityError) in
        if (completed) {
            //分享 成功
        }else{
            //分享 取消
        }
    }
    activityVC.completionWithItemsHandler = completionHandler;
}

