//
//  UITabBarItem+HWCategory.h
//  Oc-Dome
//
//  Created by 李含文 on 2019/3/28.
//  Copyright © 2019年 东莞市三心网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBarItem (HWCategory)

/** 默认颜色 */
- (UITabBarItem *(^)(UIColor *color))hw_setNormalColor;
/** 选中颜色 */
- (UITabBarItem *(^)(UIColor *color))hw_setSelectedColor;
/** 文字大小 */
- (UITabBarItem *(^)(CGFloat font))hw_setFont;
@end

NS_ASSUME_NONNULL_END
