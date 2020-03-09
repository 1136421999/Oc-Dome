//
//  UINavigationController+HWCategory.m
//  kzyjsq
//
//  Created by 李含文 on 2019/1/12.
//  Copyright © 2019年 李含文. All rights reserved.
//

#import "UINavigationController+HWCategory.h"

@implementation UINavigationController (HWCategory)

/// 全屏返回手势
- (void)hw_setScreenReturn {
    // 注意: 实现全屏滑动返回仅需在导航栏给导航栏添加UIGestureRecognizerDelegate协议
    // 获取系统自带滑动手势的target对象
    id target = self.interactivePopGestureRecognizer.delegate;
    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    // 设置手势代理，拦截手势触发
    pan.delegate = self;
    // 给导航控制器的view添加全屏滑动手势
    [self.view addGestureRecognizer:pan];
    // 禁止使用系统自带的滑动手势
    self.interactivePopGestureRecognizer.enabled = NO;
}
#pragma mark - UIGestureRecognizerDelegate
// 是否触发手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return self.childViewControllers.count > 1;
}

@end
