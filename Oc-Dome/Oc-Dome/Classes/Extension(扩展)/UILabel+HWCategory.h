//
//  UILabel+HWCategory.h
//  Oc-Dome
//
//  Created by 李含文 on 2019/3/29.
//  Copyright © 2019年 东莞市三心网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (HWCategory)
/** 快速设置默认文字 */
- (UILabel *(^)(NSString *title))hw_setText;
/** 快速设置文字大小 */
- (UILabel *(^)(CGFloat font))hw_setFont;
@end

NS_ASSUME_NONNULL_END
