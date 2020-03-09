//
//  UITabBarItem+HWCategory.m
//  Oc-Dome
//
//  Created by 李含文 on 2019/3/28.
//  Copyright © 2019年 东莞市三心网络科技有限公司. All rights reserved.
//

#import "UITabBarItem+HWCategory.h"

@implementation UITabBarItem (HWCategory)

- (UITabBarItem * _Nonnull (^)(UIColor * _Nonnull))hw_setNormalColor {
    return ^(UIColor *color) {
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        dic[NSForegroundColorAttributeName] = color;
//        [self setTitleTextAttributes:dic forState:UIControlStateNormal];
        return self;
    };
}
- (UITabBarItem * _Nonnull (^)(UIColor * _Nonnull))hw_setSelectedColor {
    return ^(UIColor *color) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        dic[NSForegroundColorAttributeName] = color;
        [self setTitleTextAttributes:dic forState:UIControlStateSelected];
        return self;
    };
}
- (UITabBarItem * _Nonnull (^)(CGFloat))hw_setFont {
    return ^(CGFloat font) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        dic[NSFontAttributeName] = [UIFont systemFontOfSize:font];
        [self setTitleTextAttributes:dic forState:UIControlStateNormal];
        return self;
    };
}
@end
