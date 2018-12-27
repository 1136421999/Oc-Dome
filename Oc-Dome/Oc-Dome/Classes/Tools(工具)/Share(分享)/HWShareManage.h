//
//  HWShareManage.h
//  Oc-Dome
//
//  Created by 李含文 on 2018/11/30.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_OPTIONS(NSUInteger, ShareType) {
    ShareTypeDefault = 0, // 友盟
    ShareTypeUIActivity, // 系统 不可自定义界面
};
@interface HWShareItem : NSObject
/** 分享的链接 */
@property(nonatomic, strong) NSString *url;
/** 分享的标题 */
@property(nonatomic, strong) NSString *title;
/** 分享的内容 */
@property(nonatomic, strong) NSString *content;
/** 分享的网络图标 */
@property(nonatomic, strong) NSString *icon;
/** 分享图片 优先取image */
@property(nonatomic, strong) UIImage *image;
/** 分享类型 没有设置默认友盟 */
@property(nonatomic, assign) ShareType shareType;

@end

@interface HWShareManage : NSObject

+ (void)showShareUIWithItem:(HWShareItem *)item;

@end


NS_ASSUME_NONNULL_END
