//
//  UIViewController+HWExtension.h
//  Oc-Dome
//
//  Created by 李含文 on 2018/11/13.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BackButtonHandlerProtocol <NSObject>
@optional
/** 返回按钮截取是否可以返回*/
- (BOOL)navigationShouldPopOnBackButton;
@end

@interface UIViewController (HWExtension) <BackButtonHandlerProtocol>
/**
 快速设置View背景颜色
 */
- (void)setBGColor;
- (void)setBGColor:(UIColor *)color;
/**
 快速设置标题名称
 name: 标题名称
 */
- (void)setTitle:(NSString *)title;

/**
 快速跳转控制器
 VCName: 控制器名称
 otherSettings:其他设置 (参数vc:要跳转的控制器)
 animated:是否执行动画
 isAddNavigation:是否添加导航条
 */
- (void)pushControllerWithVC:(UIViewController *)vc;
- (void)pushControllerWithName:(NSString *)VCName;
- (void)pushControllerWithName:(NSString *)VCName
                 otherSettings:(void(^)(UIViewController *vc))otherSettings; // 默认动画
- (void)pushControllerWithName:(NSString *)VCName
                 otherSettings:(void(^)(UIViewController *vc))otherSettings
                      animated:(BOOL)animated;
- (void)presentControllerWithVC:(UIViewController *)vc isAddNavigation:(BOOL)isAddNavigation;
- (void)presentControllerWithName:(NSString *)VCName
                    otherSettings:(void(^)(UIViewController *vc))otherSettings
                  isAddNavigation:(BOOL)isAddNavigation; // 默认动画
- (void)presentControllerWithName:(NSString *)VCName
                    otherSettings:(void(^)(UIViewController *vc))otherSettings
                  isAddNavigation:(BOOL)isAddNavigation
                         animated:(BOOL)animated;

/**
 快速返回到指定控制器
 例:快速返回到ViewController控制器 [self popToViewControllerWithName:@"ViewController"];
 */
- (void)popToViewControllerWithName:(NSString *)name;
/**
 快速返回到根控制器
 */
- (void)popToRootViewController;
@end
