//
//  HUDManage.h
//  kzyjsq
//
//  Created by 李含文 on 2018/12/3.
//  Copyright © 2018年 李含文. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    HWProgressHUDTypeText = 0,
    HWProgressHUDTypeLoading,
} HWProgressHUDType;

NS_ASSUME_NONNULL_BEGIN

@interface HUDManage : NSObject
+ (void)showHUDWithTitle:(NSString *)title;
+ (void)showLoadingHUDWithTitle:(NSString *)title;
+ (void)showLoadingHUD;
+ (void)dismiss;
@end

@interface HWProgressHUD : NSObject
+ (void)showType:(HWProgressHUDType)type text:(NSString *)text time:(NSInteger)time;
+ (void)dismiss;
@end

NS_ASSUME_NONNULL_END
