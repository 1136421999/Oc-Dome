//
//  HWWIFITools.m
//  LHWDome
//
//  Created by 李含文 on 2019/5/25.
//  Copyright © 2019年 李含文. All rights reserved.
//

#import "HWWIFITools.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#include <net/if.h>

#import "getgateway.h"

#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"

@implementation HWWIFITools
+ (nullable NSString*)hw_getCurrentIP {
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}
+ (nullable NSString *)hw_getCurreWiFiSsid {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    return [(NSDictionary*)info objectForKey:@"SSID"];
}
/// 获取热点是否开启
+ (nullable NSString *)hw_getHotSpotsType {
    NSDictionary *dict = [self getIPAddresses];
    if (dict) {
        NSArray *keys = dict.allKeys;
        for (NSString *key in keys) {
            //            if (key && [key containsString:@"bridge"])
            if (key && [key containsString:@"bridge100/ipv4"]) 
                return dict[key];
        }
    }
    return nil;
}
/// 获取所有相关IP信息
+ (NSDictionary *)getIPAddresses {
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}


// 获取路由器ip
+ (NSString *)hw_getRouterIP {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    NSLog(@"本机地址：%@",address);
                    
                    //routerIP----192.168.1.255 广播地址
                    NSLog(@"广播地址：%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)]);
                    
                    //--192.168.1.106 本机地址
                    NSLog(@"本机地址：%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]);
                    
                    //--255.255.255.0 子网掩码地址
                    NSLog(@"子网掩码地址：%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)]);
                    
                    //--en0 接口
                    //  en0       Ethernet II    protocal interface
                    //  et0       802.3             protocal interface
                    //  ent0      Hardware device interface
                    NSLog(@"接口名：%@",[NSString stringWithUTF8String:temp_addr->ifa_name]);
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    in_addr_t i = inet_addr([address cStringUsingEncoding:NSUTF8StringEncoding]);
    in_addr_t* x = &i;
    unsigned char *s = getdefaultgateway(x);
    NSString *ip=[NSString stringWithFormat:@"%d.%d.%d.%d",s[0],s[1],s[2],s[3]];
    free(s);
    return ip;
}
//- (UIView *)lineView
//{
//    if (!_lineView) {
//        _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 12, LKScreenWidth()-30, 50)];
//        CAShapeLayer *border = [CAShapeLayer layer];
//        //虚线的颜色
//        border.strokeColor = LKColorRGB(255, 206, 144).CGColor;
//        //填充的颜色
//        border.fillColor = LKColorRGB(255, 251, 244).CGColor;
//
//        //设置路径
//        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_lineView.bounds cornerRadius:5];
//        border.path = path.CGPath;
//
//        border.frame = _lineView.bounds;
//        //虚线的宽度
//        border.lineWidth = 1.f;
//        //设置线条的样式
//        border.lineCap = @"CAShapeLayerLineCap";
//        //虚线的间隔
//        border.lineDashPattern = @[@4, @2];
//
//        [_lineView.layer addSublayer:border];
//    }
//    return _lineView;
//}
@end
