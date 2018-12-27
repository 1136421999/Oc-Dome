//
//  UIImageView+HWCategory.h
//  Oc-Dome
//
//  Created by 李含文 on 2018/11/29.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (HWCategory)
/**
 快速设置图片
 name:图片urlString
 placeholderName: 占位图片名
 */
- (void)hw_setImageWithName:(NSString *)name placeholderName:(NSString *)placeholderName;

- (void)hw_setModeScaleAspectFill;
@end

NS_ASSUME_NONNULL_END
