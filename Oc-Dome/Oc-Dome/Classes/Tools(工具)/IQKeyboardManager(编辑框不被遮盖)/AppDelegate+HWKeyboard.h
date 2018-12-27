//
//  AppDelegate+HWKeyboard.h
//  LHWTestDome
//
//  Created by Hanwen on 2018/1/20.
//  Copyright © 2018年 SK丿希望. All rights reserved.
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [IQKeyboardManager sharedManager].enable = NO; // 取消插件控制
//}
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    [IQKeyboardManager sharedManager].enable = YES; // 恢复插件控制
//}
#import "AppDelegate.h"

@interface AppDelegate (HWKeyboard)
- (void)setKeyboardManager;
@end
