//
//  HWPayManage.h
//  kzyjsq
//
//  Created by 李含文 on 2018/12/17.
//  Copyright © 2018年 李含文. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DWQWECHATURLNAME @"weixin"
#define DWQALIPAYURLNAME @"alipay"

NS_ASSUME_NONNULL_BEGIN

@interface HWPayWXModel : NSObject

@property (nonatomic, copy) NSString *prepayid;

@property (nonatomic, copy) NSString *partnerid;

@property (nonatomic, copy) NSString *package;

@property (nonatomic, copy) NSString *noncestr;

@property (nonatomic, assign) UInt32 timestamp;

@property (nonatomic, copy) NSString *sign;

@property (nonatomic, copy) NSString *appid;


@end

@interface HWPayManage : NSObject
/** 单例管理 */
+ (instancetype)shareManager;

/** 注册 */
- (void)hw_registerApp;
/** 支付 */
- (void)hw_payWithOrderMessage:(id)orderMessage success:(void(^)(void))success fail:(void(^)(NSString *error))fail;
/** 收到回调后接收通知 */
- (BOOL)hw_handleUrl:(NSURL *)url;
@end

NS_ASSUME_NONNULL_END
