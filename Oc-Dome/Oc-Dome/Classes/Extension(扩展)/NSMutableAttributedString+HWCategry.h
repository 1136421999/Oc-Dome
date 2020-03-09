//
//  NSMutableAttributedString+HWCategry.h
//  OC富文本
//
//  Created by 李含文 on 2019/1/7.
//  Copyright © 2019年 SK丿希望. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (HWCategry)

/** 修改文字颜色 range:没有默认填充全部 */
- (NSMutableAttributedString *)hw_color:(UIColor *)color;
- (NSMutableAttributedString * (^)(UIColor *color))hw_color;
/** 修改文字颜色 range:没有默认填充全部 */
- (NSMutableAttributedString *)hw_color:(UIColor *)color range:(NSRange)range;

/** 修改文字大小 range:没有默认填充全部 */
- (NSMutableAttributedString *)hw_font:(CGFloat)font;
/** 修改文字大小 range:没有默认填充全部 */
- (NSMutableAttributedString *)hw_font:(CGFloat)font range:(NSRange)range;

/** 修改背景颜色 range:没有默认填充全部 */
- (NSMutableAttributedString *)hw_backgroundColor:(UIColor *)color;
/** 修改背景颜色 range:没有默认填充全部 */
- (NSMutableAttributedString *)hw_backgroundColor:(UIColor *)color range:(NSRange)range;

/** 删除线 range:没有默认填充全部 */
- (NSMutableAttributedString *)hw_deleteLine;
/** 删除线 range:没有默认填充全部 */
- (NSMutableAttributedString *)hw_deleteLineWithRange:(NSRange)range;

- (NSMutableAttributedString *)hw_deleteLineWithColor:(UIColor *)color;
/** 下划线 range:没有默认填充全部 */
- (NSMutableAttributedString *)hw_buttomLine;
/** 下划线 range:没有默认填充全部 */
- (NSMutableAttributedString *)hw_buttomLineWithRange:(NSRange)range;

- (NSMutableAttributedString *)hw_buttomLineWithColor:(UIColor *)color;

/**
 拼接富文本
 @param attr 要拼接的富文本
 @return 新的富文本
 */
- (NSMutableAttributedString *)hw_addAttributed:(NSAttributedString *)attr;
/**
 插入图片
 @param imageName 图片名
 @param bounds 图片尺寸
 @param index 第几位
 @return <#return value description#>
 */
- (NSMutableAttributedString *)hw_insertImage:(NSString *)imageName bounds:(CGRect)bounds atIndex:(NSInteger)index;
/**
 追加图片到当前富文本最后
 @param imageName 图片名
 @param bounds 图片尺寸
 @return <#return value description#>
 */
- (NSMutableAttributedString *)hw_addImage:(NSString *)imageName bounds:(CGRect)bounds;
@end

NS_ASSUME_NONNULL_END
