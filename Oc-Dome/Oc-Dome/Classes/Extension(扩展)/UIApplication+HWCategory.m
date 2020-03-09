//
//  UIApplication+HWCategory.m
//  kzyjsq
//
//  Created by 李含文 on 2018/12/10.
//  Copyright © 2018年 李含文. All rights reserved.
//

#import "UIApplication+HWCategory.h"

@implementation UIApplication (HWCategory)

/** 获取当前版本号 */
+ (NSString *)hw_getAppVersion {
    NSString *app_Version = [[self hw_getinfoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}
+ (NSDictionary *)hw_getinfoDictionary {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return infoDictionary;
}
@end
