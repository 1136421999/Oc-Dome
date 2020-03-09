//
//  UILabel+HWCategory.m
//  Oc-Dome
//
//  Created by 李含文 on 2019/3/29.
//  Copyright © 2019年 东莞市三心网络科技有限公司. All rights reserved.
//

#import "UILabel+HWCategory.h"

@implementation UILabel (HWCategory)

- (UILabel * _Nonnull (^)(CGFloat))hw_setFont {
    return ^(CGFloat font) {
        self.font = [UIFont systemFontOfSize:font];
        return self;
    };
}

- (UILabel * _Nonnull (^)(NSString * _Nonnull))hw_setText {
    return ^(NSString *text) {
        self.text = text;
        return self;
    };
}

@end
