//
//  UIView+HWCategory.h
//  Oc-Dome
//
//  Created by 李含文 on 2018/11/29.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE // 动态刷新
NS_ASSUME_NONNULL_BEGIN

@interface UIView (HWCategory)
/** 用于交互方法 */
+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2;
/**  起点x坐标  */
@property (nonatomic, assign) CGFloat x;
/**  起点y坐标  */
@property (nonatomic, assign) CGFloat y;
/**  中心点x坐标  */
@property (nonatomic, assign) CGFloat centerX;
/**  中心点y坐标  */
@property (nonatomic, assign) CGFloat centerY;
/**  宽度  */
@property (nonatomic, assign) CGFloat width;
/**  高度  */
@property (nonatomic, assign) CGFloat height;
/**  顶部  */
@property (nonatomic, assign) CGFloat top;
/**  底部  */
@property (nonatomic, assign) CGFloat bottom;
/**  左边  */
@property (nonatomic, assign) CGFloat left;
/**  右边  */
@property (nonatomic, assign) CGFloat right;
/**  size  */
@property (nonatomic, assign) CGSize size;
/**  origin */
@property (nonatomic, assign) CGPoint origin;
/** 可视化设置边框宽度 */
@property (nonatomic, assign)IBInspectable CGFloat borderWidth;
/** 可视化设置边框颜色 */
@property (nonatomic, strong)IBInspectable UIColor *borderColor;
/** 可视化设置圆角 */
@property (nonatomic, assign)IBInspectable CGFloat cornerRadius;


/**
 快速给View添加4边阴影
 参数:阴影透明度，默认0
 */
- (void)addProjectionWithShadowOpacity:(CGFloat)shadowOpacity;
- (void)addRound:(CGFloat)radius addShadow:(CGFloat)opacity;
/**
 快速给View添加4边框
 参数:边框宽度
 */
- (void)addBorderWithWidth:(CGFloat)width;
/**
 快速给View添加4边框
 width:边框宽度
 borderColor:边框颜色
 */
- (void)addBorderWithWidth:(CGFloat)width borderColor:(UIColor *)borderColor;
/**
 快速给View添加圆角
 参数:圆角半径
 */
- (void)addRoundedCornersWithRadius:(CGFloat)radius;
- (void)addRounded;
/**
 快速给View添加圆角
 radius:圆角半径
 corners:且那几个角
 类型共有以下几种:
 typedef NS_OPTIONS(NSUInteger, UIRectCorner) {
 UIRectCornerTopLeft,
 UIRectCornerTopRight ,
 UIRectCornerBottomLeft,
 UIRectCornerBottomRight,
 UIRectCornerAllCorners
 };
 使用案例:[self.mainView addRoundedCornersWithRadius:10 byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight]; // 切除了左下 右下
 */
- (void)addRoundedCornersWithRadius:(CGFloat)radius byRoundingCorners:(UIRectCorner)corners;
/**
 *  通过 CAShapeLayer 方式绘制虚线
 *
 *  param lineLength:     虚线的宽度
 *  param lineSpacing:    虚线的间距
 *  param lineColor:      虚线的颜色
 *  param lineDirection   虚线的方向  YES 为水平方向， NO 为垂直方向
 **/
- (void)hw_drawDottedLineWithLineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal;
/**判断View是否显示在屏幕上*/
- (BOOL)hw_isDisplayedInScreen;
/** 快速加载xib */
+ (id)hw_loadViewFromNib;
/** 快速添加点击手势 */
- (void)hw_addTapGesture:(void(^)(void))action;
@end

NS_ASSUME_NONNULL_END
