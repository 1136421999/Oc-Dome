//
//  UINavigationController+HWCategory.h
//  kzyjsq
//
//  Created by 李含文 on 2019/1/12.
//  Copyright © 2019年 李含文. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (HWCategory)<UIGestureRecognizerDelegate>
/** 设置全屏返回手势 有问题 */
- (void)hw_setScreenReturn;
@end

NS_ASSUME_NONNULL_END
