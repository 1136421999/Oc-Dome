//
//  UICollectionView+HWExtension.h
//  Swift-UICollectionView
//
//  Created by 李含文 on 2018/9/1.
//  Copyright © 2018年 李含文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HWExtension)
+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2;
@end

@interface UICollectionView (HWExtension)
@property(nonatomic, copy) void(^actionBlock)(BOOL tag);
@end
