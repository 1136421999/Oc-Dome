//
//  BaseViewController.h
//  kzyjsq
//
//  Created by 李含文 on 2018/12/1.
//  Copyright © 2018年 李含文. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController
- (void)switchNavColor:(UIColor *)color;
- (void)switchWhiteColor;
- (void)switchBlackColor;
- (void)switchClearColor;
- (void)switchGradientColor;
/**
 快速设置返回按钮
 @param action 点击按钮回调
 */
- (void)setBackButton:(void(^)(void))action;
@end

NS_ASSUME_NONNULL_END
