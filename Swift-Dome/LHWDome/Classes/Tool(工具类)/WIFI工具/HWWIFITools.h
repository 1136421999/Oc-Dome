//
//  HWWIFITools.h
//  LHWDome
//
//  Created by 李含文 on 2019/5/25.
//  Copyright © 2019年 李含文. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HWWIFITools : NSObject
/// 获取ip
+ (nullable NSString*)hw_getCurrentIP;
/// 获取WIFI名称
+ (nullable NSString *)hw_getCurreWiFiSsid;
/// 获取热点ip 有即是打开 反正
+ (nullable NSString *)hw_getHotSpotsType;
/// 获取路由器ip
+ (NSString *)hw_getRouterIP;
@end

NS_ASSUME_NONNULL_END
