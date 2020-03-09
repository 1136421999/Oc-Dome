//
//  Macro.h
//  kzyjsq
//
//  Created by 李含文 on 2018/12/1.
//  Copyright © 2018年 李含文. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

/* 弱引用 */
#define HWWeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;
/* 状态栏高度 */
#define hw_statusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)
/* 是否是iPhoneX系列 */
#define isiPhoneX (hw_statusBarHeight>20?YES:NO)
/* 导航栏高度 */
#define hw_navHeight (isiPhoneX?88.0:64.0)
/* 导航栏高度 */
#define hw_tabBarHeight (isiPhoneX?83.0:49.0)
// 屏幕比例
#define hw_RATIO(w) w*kUIScreenW/375.0
#define hw_RATIO(h)  h*kUIScreenH/(iPhoneX?812:667.0)
/* 底部安全区域 */
#define hw_bottomSafeHeight (isiPhoneX? 34:0) // iPhone X 递补弧形的高度
// MARK: - 颜色相关
/** 线颜色 */
#define hw_lineColor [@"DFE3E6" hw_hexColor]
/** 背景颜色 */
#define hw_BGColor [@"F5F7FA" hw_hexColor]
/** 主要颜色 */
#define hw_MainColor [@"319FFA" hw_hexColor]
/** 渐变颜色 */
#define hw_GradientColor [UIColor hw_colorWithGradientStyle:HWGradientStyleLeftToRight withFrame:[UIScreen mainScreen].bounds andColors:@[[@"609EFA" hw_hexColor], [@"89BEFF" hw_hexColor]]]
#pragma mark - 尺寸相关
#define HWScreenW [UIScreen mainScreen].bounds.size.width
#define HWScreenH [UIScreen mainScreen].bounds.size.height


#ifdef DEBUG // 开发
#define HWLog(...) NSLog(@"%s %d \n%@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else // 生产
#define HWLog(...) //NSLog(@"%s %d \n%@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#endif

#endif /* Macro_h */
