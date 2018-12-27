//
//  UIImageView+HWCategory.m
//  Oc-Dome
//
//  Created by 李含文 on 2018/11/29.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

#import "UIImageView+HWCategory.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (HWCategory)
- (void)hw_setImageWithName:(NSString *)name placeholderName:(NSString *)placeholderName {
    if (placeholderName.length > 0) {
        [self sd_setImageWithURL:[NSURL URLWithString:name] placeholderImage:[UIImage imageNamed:placeholderName]];
    } else {
        [self sd_setImageWithURL:[NSURL URLWithString:name] placeholderImage:[UIImage imageNamed:@"占位图"]];
    }
}
- (void)hw_setModeScaleAspectFill {
    self.layer.cornerRadius = self.bounds.size.width/2;
    self.clipsToBounds = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
}
@end
