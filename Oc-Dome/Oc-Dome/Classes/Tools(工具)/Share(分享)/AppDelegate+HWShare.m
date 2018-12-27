//
//  AppDelegate+HWShare.m
//  YuYinPingCe
//
//  Created by Hanwen on 2018/1/23.
//  Copyright © 2018年 SK丿希望. All rights reserved.
//

#import "AppDelegate+HWShare.h"
#import <UMCommon/UMCommon.h>
#import <UShareUI/UShareUI.h>
#import <UMShare/UMShare.h>

@implementation AppDelegate (HWShare)

- (void)setUpUM{
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    /* 设置友盟appkey */
    [UMConfigure initWithAppkey:UMAppkey channel:@"App Store"];
    if (WXAppkey.length > 0) {
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WXAppkey appSecret:WXAppSecret redirectURL:nil];
    }
    if (QQAppkey.length > 0) {
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAppkey appSecret:QQAppSecret redirectURL:nil];
    }
}
// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
@end
