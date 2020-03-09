//
//  UIColor+HWExtension.h
//  Oc-Dome
//
//  Created by 李含文 on 2018/11/12.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM (NSUInteger, HWGradientStyle) {
    
    HWGradientStyleLeftToRight,
    
    HWGradientStyleRadial,
    
    HWGradientStyleTopToBottom
};
@interface UIColor (HWCategory)
/** 16进制转颜色*/
+ (UIColor *)hw_colorWithHex:(NSString *)hexString alpha:(CGFloat)alpha;
+ (UIColor *)hw_colorWithHex:(NSString *)hexString;

+ (UIColor *)hw_colorWithGradientStyle:(HWGradientStyle)gradientStyle withFrame:(CGRect)frame andColors:(NSArray *)colors;

/** 随机色 */
+ (UIColor *)hw_randomColor;

/**
 修改颜色的透明度
 @param alpha 透明度
 @return 新color
 */
- (UIColor *)hw_alpha:(CGFloat)alpha;
- (UIColor *(^)(CGFloat alpha))hw_setAlpha;
@end
