//
//  UIView+HWCategory.m
//  Oc-Dome
//
//  Created by 李含文 on 2018/11/29.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

#import "UIView+HWCategory.h"
#import <objc/runtime.h>


static NSString *hw_GestureActionKey = @"hw_GestureActionKey";
@implementation UIView (HWCategory)
+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2 {
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}
#pragma mark - frame
- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center; 
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}
- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}


- (CGFloat)bottom {
    return self.frame.size.height + self.frame.origin.y;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.size.width + self.frame.origin.x;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    [self addRoundedCornersWithRadius:cornerRadius];
}
- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}
- (void)setBorderWidth:(CGFloat)borderWidth {
    if (borderWidth < 0) return;
    self.layer.borderWidth = borderWidth;
}
- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}
- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}
- (UIColor *)borderColor {
    return [[UIColor alloc] initWithCGColor:self.layer.borderColor];
}

#pragma mark - 快速添加阴影
- (void)addProjectionWithShadowOpacity:(CGFloat)shadowOpacity {
    self.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移2，y向下偏移6，默认(0, -3),这个跟shadowRadius配合使用
    self.layer.shadowOpacity = shadowOpacity;//阴影透明度，默认0
    self.layer.shadowRadius = 5;//阴影半径，默认3
}
- (void)addBorderWithWidth:(CGFloat)width {
    self.layer.borderWidth = width;
    self.layer.borderColor = [UIColor blackColor].CGColor;
}
- (void)addBorderWithWidth:(CGFloat)width borderColor:(UIColor *)borderColor {
    self.layer.borderWidth = width;
    self.layer.borderColor = borderColor.CGColor;
}
- (void)addRoundedCornersWithRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}
- (void)addRounded {
    self.layer.cornerRadius = self.height/2;
    self.layer.masksToBounds = YES;
}
- (void)addRound:(CGFloat)radius addShadow:(CGFloat)opacity {
    if (self.layer.cornerRadius != radius) {
        self.layer.cornerRadius = radius;
        self.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        self.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移2，y向下偏移6，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowOpacity = opacity;//阴影透明度，默认0
        self.layer.shadowRadius = 5;//阴影半径，默认3
    }
}
- (void)addRoundedCornersWithRadius:(CGFloat)radius byRoundingCorners:(UIRectCorner)corners{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

/**
 *  通过 CAShapeLayer 方式绘制虚线
 *
 *  param lineLength:     虚线的宽度
 *  param lineSpacing:    虚线的间距
 *  param lineColor:      虚线的颜色
 *  param lineDirection   虚线的方向  YES 为水平方向， NO 为垂直方向
 **/
- (void)hw_drawDottedLineWithLineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.bounds];
    if (isHorizonal) {
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame))];
    } else{
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame)/2)];
    }
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    if (isHorizonal) {
        [shapeLayer setLineWidth:CGRectGetHeight(self.frame)];
    } else {
        [shapeLayer setLineWidth:CGRectGetWidth(self.frame)];
    }
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    if (isHorizonal) {
        CGPathAddLineToPoint(path, NULL,CGRectGetWidth(self.frame), 0);
    } else {
        CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(self.frame));
    }
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [self.layer addSublayer:shapeLayer];
}

/**判断View是否显示在屏幕上*/
- (BOOL)hw_isDisplayedInScreen {
    if(self == nil){
        return NO;
    }
    CGRect screenRect = [UIScreen mainScreen].bounds;
    //转换view对应window的Rect
    CGRect rect = [self convertRect:self.frame fromView:nil];
    if(CGRectIsEmpty(rect) || CGRectIsNull(rect)){
        return NO;
    }
    //若view 隐藏
    if(self.hidden){
        return NO;
    }
    //若没有superView
    if(self.superview == nil){
        return NO;
    }
    // 若size 为CGRectZero
    if(CGSizeEqualToSize(rect.size, CGSizeZero)){
        return NO;
    }
    // 获取 该view 与window 交叉的Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if(CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return NO;
    }
    return YES;
}


+ (id)hw_loadViewFromNib {
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    if (view) {
        return view;
    } else {
        return [[UIView alloc] init];
    }
}


- (void)hw_addTapGesture:(void(^)(void))action {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickGesture)];
    tap.numberOfTouchesRequired = 1;//点击出点需要几个点
    tap.numberOfTapsRequired = 1;//连续点击几次才能引发手势事件
    //上面两个参数默认不写的时候，系统默认是1；
    self.actionBlock = action;
    [self addGestureRecognizer:tap];
}

- (void)clickGesture {
    if (self.actionBlock) {
        self.actionBlock();
    }
}
- (void)setActionBlock:(void (^)(void))actionBlock {
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(hw_GestureActionKey), actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(void))actionBlock {
    return objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(hw_GestureActionKey));
}

@end
