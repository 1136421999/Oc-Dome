//
//  HWPayManage.m
//  kzyjsq
//
//  Created by 李含文 on 2018/12/17.
//  Copyright © 2018年 李含文. All rights reserved.
//

#import "HWPayManage.h"
#import <WXApi.h>
#import <AlipaySDK/AlipaySDK.h>

// 回调url地址为空
#define DWQTIP_CALLBACKURL @"url地址不能为空！"
// 订单信息为空字符串或者nil
#define DWQTIP_ORDERMESSAGE @"订单信息不能为空！"
// 没添加 URL Types
#define DWQTIP_URLTYPE @"请先在Info.plist 添加 URL Type"
// 添加了 URL Types 但信息不全
#define DWQTIP_URLTYPE_SCHEME(name) [NSString stringWithFormat:@"请先在Info.plist 的 URL Type 添加 %@ 对应的 URL Scheme",name]

@implementation HWPayWXModel

@end

@interface HWPayManage ()<WXApiDelegate>
// 缓存appScheme
@property (nonatomic,strong)NSMutableDictionary *appSchemeDict;
/** <#注释#> */
@property(nonatomic, copy) void(^successBlock)(void);
/** <#注释#> */
@property(nonatomic, copy) void(^failBlock)(NSString *error);
@end

@implementation HWPayManage

+ (instancetype)shareManager{
    static HWPayManage *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (void)hw_registerApp {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *urlTypes = dict[@"CFBundleURLTypes"];
    NSAssert(urlTypes, DWQTIP_URLTYPE);
    for (NSDictionary *urlTypeDict in urlTypes) {
        NSString *urlName = urlTypeDict[@"CFBundleURLName"];
        NSArray *urlSchemes = urlTypeDict[@"CFBundleURLSchemes"];
        NSAssert(urlSchemes.count, DWQTIP_URLTYPE_SCHEME(urlName));
        // 一般对应只有一个
        NSString *urlScheme = urlSchemes.lastObject;
        if ([urlName isEqualToString:DWQWECHATURLNAME]) {
            [self.appSchemeDict setValue:urlScheme forKey:DWQWECHATURLNAME];
            // 注册微信
            [WXApi registerApp:urlScheme];
        } else if ([urlName isEqualToString:DWQALIPAYURLNAME]){
            // 保存支付宝scheme，以便发起支付使用
            [self.appSchemeDict setValue:urlScheme forKey:DWQALIPAYURLNAME];
        }
    }
}

- (void)hw_payWithOrderMessage:(id)orderMessage success:(void(^)(void))success fail:(void(^)(NSString *error))fail {
    self.successBlock = success;
    self.failBlock = fail;
    if (orderMessage[@"info"]) { // 支付宝支付
        [[AlipaySDK defaultService] payOrder:orderMessage[@"info"] fromScheme:self.appSchemeDict[DWQALIPAYURLNAME] callback:^(NSDictionary *resultDic) {}];
    } else { // 微信支付
        if (![WXApi isWXAppInstalled]) { // 没有安装微信
            self.failBlock(@"没有安装微信");
            return;
        }
        if (![WXApi isWXAppSupportApi]) { // 当前版本微信不支持微信支付
            self.failBlock(@"当前版本微信不支持微信支付");
            return;
        }
        HWPayWXModel *model = [HWPayWXModel mj_objectWithKeyValues:orderMessage];
        PayReq *payReq = [[PayReq alloc] init];
        payReq.partnerId = model.partnerid;
        payReq.prepayId = model.prepayid;
        payReq.nonceStr = model.noncestr;
        payReq.timeStamp = model.timestamp;
        payReq.package = model.package;
        payReq.sign = model.sign;
        payReq.openID = model.appid;
        [WXApi sendReq:payReq];
    }
}
- (BOOL)hw_handleUrl:(NSURL *)url {
    NSAssert(url, DWQTIP_CALLBACKURL);
    if ([url.host isEqualToString:@"pay"]) {// 微信
        return [WXApi handleOpenURL:url delegate:self];
    } else if ([url.host isEqualToString:@"safepay"]) {// 支付宝
        __weak typeof(self) weakSelf = self;
        // 支付跳转支付宝钱包进行支付，处理支付结果(在app被杀模式下，通过这个方法获取支付结果）
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [weakSelf showResult:resultDic];
        }];
        return YES;
    } else{
        return NO;
    }
}
- (void)showResult:(NSDictionary *)resultDic {
    NSString *resultStatus = resultDic[@"resultStatus"];
    if ([resultStatus isEqualToString:@"6001"]) {
        self.failBlock(@"用户中途取消");
    } else if ([resultStatus isEqualToString:@"6002"]) {
        self.failBlock(@"网络连接出错");
    } else if ([resultStatus isEqualToString:@"8000"]) {
        self.failBlock(@"正在处理中");
    } else if ([resultStatus isEqualToString:@"4000"]) {
        self.failBlock(@"订单支付失败");
    } else if ([resultStatus isEqualToString:@"9000"]) {
        self.successBlock();
    } else {
        self.failBlock(@"订单支付失败");
    }
}
#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    // 判断支付类型
    if([resp isKindOfClass:[PayResp class]]){
        //支付回调
        NSString *errStr = resp.errStr;
        switch (resp.errCode) {
            case 0:
                self.successBlock();
                errStr = @"订单支付成功";
                break;
            case -1:
                errStr = resp.errStr;
                self.failBlock(errStr);
                break;
            case -2:
                errStr = @"用户中途取消";
                self.failBlock(errStr);
                break;
            default:
                errStr = resp.errStr;
                self.failBlock(errStr);
                break;
        }
    }
}
- (NSMutableDictionary *)appSchemeDict{
    if (_appSchemeDict == nil) {
        _appSchemeDict = [NSMutableDictionary dictionary];
    }
    return _appSchemeDict;
}
@end
