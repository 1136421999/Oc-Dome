//
//  UITextView+HWCategory.h
//  Oc-Dome
//
//  Created by 李含文 on 2018/12/1.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

// 在定义类的前面加上IB_DESIGNABLE宏
IB_DESIGNABLE // 动态刷新
NS_ASSUME_NONNULL_BEGIN

@interface UITextView (HWCategory)

@property (nonatomic, strong) IBInspectable NSString *placeholder;

@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;

@end


NS_ASSUME_NONNULL_END
