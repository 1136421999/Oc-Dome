//
//  UIApplication+HWCategory.h
//  kzyjsq
//
//  Created by 李含文 on 2018/12/10.
//  Copyright © 2018年 李含文. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (HWCategory)
/* 获取app版本 */
+ (NSString *)hw_getAppVersion;
@end

NS_ASSUME_NONNULL_END
