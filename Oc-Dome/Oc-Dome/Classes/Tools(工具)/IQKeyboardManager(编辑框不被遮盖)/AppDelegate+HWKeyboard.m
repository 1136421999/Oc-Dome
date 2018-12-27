//
//  AppDelegate+HWKeyboard.m
//  LHWTestDome
//
//  Created by Hanwen on 2018/1/20.
//  Copyright © 2018年 SK丿希望. All rights reserved.
//

#import "AppDelegate+HWKeyboard.h"
#import "IQKeyboardManager.h"

@implementation AppDelegate (HWKeyboard)
- (void)setKeyboardManager {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    // 将上面的Done条隐藏
    manager.enableAutoToolbar = NO;
    // 防止IQKeyboardManager让rootview上滑过度,默认是YES
    manager.preventShowingBottomBlankSpace = NO;
    // 点击背景键盘下去
    manager.shouldResignOnTouchOutside = YES;
    //    //设置为文字
    //    manager.toolbarDoneBarButtonItemText = @"完成";
    //    //设置为图片
    //    manager.toolbarDoneBarButtonItemImage = [UIImage imageNamed:@"imageName"];
    //    // 修改工具条上字体的颜色
    //    manager.shouldToolbarUsesTextFieldTintColor = NO;
    //    manager.toolbarTintColor = [UIColor redColor];
    //    // 设置输入框与工具条的间距，默认为10.0f
    //    manager.keyboardDistanceFromTextField = 10.0f;
}
@end
