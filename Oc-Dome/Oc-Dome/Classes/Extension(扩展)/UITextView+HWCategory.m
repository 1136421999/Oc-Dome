//
//  UITextView+HWCategory.m
//  Oc-Dome
//
//  Created by 李含文 on 2018/12/1.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

#import "UITextView+HWCategory.h"
#import <objc/runtime.h>

static NSString const *placeholderKey = @"placeholderKey";
static NSString const *placeholderLabelKey = @"placeholderLabelKey";
@implementation UITextView (HWCategory)
- (void)setPlaceholder:(NSString *)placeholder {
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(placeholderKey), placeholder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (![self.subviews containsObject:self.placeholderLabel]) {
        [self getPlaceholderLabel];
        self.placeholderLabel.text = placeholder;
    } else {
        self.placeholderLabel.text = placeholder;
    }
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    if (![self.subviews containsObject:self.placeholderLabel]) { return; }
    self.placeholderLabel.textColor = placeholderColor;
}
- (UIColor *)placeholderColor {
    return self.placeholderLabel.textColor;
}
- (NSString *)placeholder {
    return objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(placeholderKey));
}
- (void)setPlaceholderLabel:(UILabel *)placeholderLabel {
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(placeholderLabelKey), placeholderLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)placeholderLabel {
    id label = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(placeholderLabelKey));
    if (!label) {
        [self getPlaceholderLabel];
    }
    return label;
}
- (UILabel *)getPlaceholderLabel {
    if (!self.font) {
        self.font = [UIFont systemFontOfSize:14];
    }
    UILabel *lab = [[UILabel alloc] initWithFrame:self.bounds];
    lab.numberOfLines = 0;
    lab.font = self.font;
    lab.textColor = [UIColor lightGrayColor];
    [self addSubview:lab];
    [self setValue:lab forKey:@"_placeholderLabel"];
    [self setPlaceholderLabel:lab];
    [self sendSubviewToBack:self.placeholderLabel];
    return lab;
}
@end




