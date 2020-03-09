//
//  UIButton+HWCategory.h
//  Oc-Dome
//
//  Created by 李含文 on 2018/11/30.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    /// 图片在左，文字在右
    HWPositionStyleDefault = 0,
    /// 图片在右，文字在左
    HWPositionStyleRight,
    /// 图片在上，文字在下
    HWPositionStyleTop,
    /// 图片在下，文字在上
    HWPositionStyleBottom,
} HWPositionStyle;
NS_ASSUME_NONNULL_BEGIN

@interface UIButton (HWCategory)

@property (nonatomic, copy) void(^actionBlock)(void);

/** 快速设置默认文字 */
- (UIButton *(^)(NSString *title))hw_setTitle_normal;
/** 快速设置选中文字 */
- (UIButton *(^)(NSString *title))hw_setTitle_selected;
/** 快速设置默认文字颜色 */
- (UIButton *(^)(UIColor *color))hw_setTitleColor_normal;
/** 快速设置选中文字颜色 */
- (UIButton *(^)(UIColor *color))hw_setTitleColor_selected;
/** 快速设置文字大小 */
- (UIButton *(^)(CGFloat font))hw_setFont;
/** 快速设置默认图片 */
- (UIButton *(^)(NSString *name))hw_setImage_normal;
/** 快速设置选中图片 */
- (UIButton *(^)(NSString *name))hw_setImage_selected;
/**
 倒计时
 @param time 倒计时时间 以秒未单位
 */
- (void)hw_countdownWithTime:(NSInteger)time;
/**
 倒计时
 @param time 倒计时时间 以秒未单位
 @param action 定时完成后的回调
 */
- (void)hw_countdownWithTime:(NSInteger)time action:(void(^)(void))action;

/**
 *  设置图片与文字位置
 *
 *  @param positionStyle     图片位置样式
 *  @param spacing           图片与文字之间的间距
 */
- (void)hw_imagePositionStyle:(HWPositionStyle)positionStyle spacing:(CGFloat)spacing;
@end

NS_ASSUME_NONNULL_END
