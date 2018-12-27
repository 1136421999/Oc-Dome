//
//  HWPayPopoManage.h
//  kzyjsq
//
//  Created by 李含文 on 2018/12/17.
//  Copyright © 2018年 李含文. All rights reserved.
//

/*使用案例
 [HWPayPopoManage showTitle:@"扣除积分数量" moeny:@"1000" action:^(NSString * _Nonnull password) {
 HWLog(@"%@",password);
 } otherAction:^{
 HWLog(@"点击了忘记支付密码");
 }];
 */
#import <Foundation/Foundation.h>
#import "HWPayPopoView.h"
NS_ASSUME_NONNULL_BEGIN

@interface HWPayPopoManageView : UIView
/** <#注释#> */
@property(nonatomic, copy) void(^touchesBeganBlock)(void);
@end

@interface HWPayPopoManage : NSObject

/**
 快速弹出支付弹框

 @param title 标题
 @param money 显示的money
 @param action 点击确认回调
 @param otherAction 点击忘记密码回调
 */
+ (void)showTitle:(NSString *)title moeny:(NSString *)money action:(void(^)(NSString *password))action otherAction:(void(^)(void))otherAction;
@end

NS_ASSUME_NONNULL_END
