//
//  NSString+HWCategory.h
//  Oc-Dome
//
//  Created by 李含文 on 2018/11/29.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (HWCategory)
/** 格式化时间 传入毫秒
 [self.model.createtime hw_Dataformatting:@"yyyy-MM-dd HH:mm"];
 */
- (NSString *)hw_Dataformatting:(NSString *)fomrdata;

#pragma mark - 去掉小数点之后的0
/** 去掉小数点之后的0 */
- (NSString*)hw_removeFloatAllZero;
/** 字符串分割根据"," */
- (NSArray *)hw_segmentation;
- (NSArray *)hw_segmentationWithSub:(NSString *)sub;
/** 16进制字符串转颜色 */
- (UIColor *)hw_hexColor;
/**
 获取文字尺寸
 @param font 文字大小
 @param maxSize 支持的最大尺寸
 @return 尺寸
 */
- (CGSize)hw_getSizeWithFont:(UIFont *)font addMaxSize:(CGSize)maxSize;
/**
 获取文字高度
 @param font 文字大小
 @param maxWidth 支持的最大宽度
 @return 高度
 */
- (CGFloat)hw_getHeightWithFont:(CGFloat)font addMaxWidth:(CGFloat)maxWidth;
/**
 获取文字宽度
 @param font 文字大小
 @param maxHeight 支持的最大高度
 @return 宽度
 */
- (CGFloat)hw_getWidthWithFont:(CGFloat)font addMaxHeight:(CGFloat)maxHeight;
@end

NS_ASSUME_NONNULL_END
