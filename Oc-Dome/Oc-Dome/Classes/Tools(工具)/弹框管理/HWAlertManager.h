//
//  HWAlertManager.h
//  kzyjsq
//
//  Created by 李含文 on 2018/12/4.
//  Copyright © 2018年 李含文. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HWAlertManager : NSObject

/**
 底部弹框
 @param title 标题
 @param message 内容
 @param titles 按钮标题
 @param actionBlock 点击回调
 */
+ (void)hw_showSheet:(id _Nullable)title message:(id _Nullable)message actionTitles:(NSArray<NSString *> *)titles actionBlock:(void(^)(NSInteger index))actionBlock;

/**
 中间弹框
 @param title 标题
 @param message 内容
 @param titles 按钮标题
 @param actionBlock 点击回调
 */
+ (void)hw_showAlert:(id _Nullable)title message:(id _Nullable)message actionTitles:(NSArray<NSString *> *)titles actionBlock:(void(^)(NSInteger index))actionBlock;
@end

NS_ASSUME_NONNULL_END
