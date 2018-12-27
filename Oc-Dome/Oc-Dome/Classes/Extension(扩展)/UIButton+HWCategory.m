//
//  UIButton+HWCategory.m
//  Oc-Dome
//
//  Created by 李含文 on 2018/11/30.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

#import "UIButton+HWCategory.h"
#import <objc/runtime.h>


static NSString  * const hw_ActionBlockButtonKey = @"hw_ActionBlockButtonKey";

@implementation UIButton (HWCategory)

- (void)setActionBlock:(void (^)(void))actionBlock {
    [self addTarget:self action:@selector(hw_buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(hw_ActionBlockButtonKey), actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(void))actionBlock {
    return objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(hw_ActionBlockButtonKey));
}
- (void)hw_buttonClick:(UIButton *)btn {
    if (self.actionBlock != nil) {
        self.actionBlock();
    }
}
- (void)hw_countdownWithTime:(NSInteger)time {
    [self hw_countdownWithTime:time action:^{
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
    }];
}
- (void)hw_countdownWithTime:(NSInteger)time action:(void(^)(void))action {
    __block NSInteger tempSecond = time;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (tempSecond <= 1) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.enabled = YES;
                action();
            });
        } else {
            tempSecond--;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.enabled = NO;
                NSString *text = [NSString stringWithFormat:@"%lds", (long)tempSecond];
                self.titleLabel.text = text;
                [self setTitle:text forState:UIControlStateNormal];
            });
        }
    });
    dispatch_resume(timer);
}

- (void)hw_imagePositionStyle:(HWPositionStyle)positionStyle spacing:(CGFloat)spacing {
    if (positionStyle == HWPositionStyleDefault) {
        if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft) {
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
        } else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight) {
            self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
        } else {
            self.imageEdgeInsets = UIEdgeInsetsMake(0, - 0.5 * spacing, 0, 0.5 * spacing);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, 0.5 * spacing, 0, - 0.5 * spacing);
        }
    } else if (positionStyle == HWPositionStyleRight) {
        CGFloat imageW = self.imageView.image.size.width;
        CGFloat titleW = self.titleLabel.frame.size.width;
        if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft) {
            self.imageEdgeInsets = UIEdgeInsetsMake(0, titleW + spacing, 0, 0);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageW, 0, 0);
        } else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight) {
            self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, - titleW);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, imageW + spacing);
        } else {
            CGFloat imageOffset = titleW + 0.5 * spacing;
            CGFloat titleOffset = imageW + 0.5 * spacing;
            self.imageEdgeInsets = UIEdgeInsetsMake(0, imageOffset, 0, - imageOffset);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, - titleOffset, 0, titleOffset);
        }
    } else if (positionStyle == HWPositionStyleTop) {
        CGFloat imageW = self.imageView.frame.size.width;
        CGFloat imageH = self.imageView.frame.size.height;
        CGFloat titleIntrinsicContentSizeW = self.titleLabel.intrinsicContentSize.width;
        CGFloat titleIntrinsicContentSizeH = self.titleLabel.intrinsicContentSize.height;
        self.imageEdgeInsets = UIEdgeInsetsMake(- titleIntrinsicContentSizeH - spacing, 0, 0, - titleIntrinsicContentSizeW);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageW, - imageH - spacing, 0);
    } else if (positionStyle == HWPositionStyleBottom) {
        CGFloat imageW = self.imageView.frame.size.width;
        CGFloat imageH = self.imageView.frame.size.height;
        CGFloat titleIntrinsicContentSizeW = self.titleLabel.intrinsicContentSize.width;
        CGFloat titleIntrinsicContentSizeH = self.titleLabel.intrinsicContentSize.height;
        self.imageEdgeInsets = UIEdgeInsetsMake(titleIntrinsicContentSizeH + spacing, 0, 0, - titleIntrinsicContentSizeW);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageW, imageH + spacing, 0);
    }
}
@end
