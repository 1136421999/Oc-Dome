//
//  HWShareManage.m
//  Oc-Dome
//
//  Created by 李含文 on 2018/11/30.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

#import "HWShareManage.h"
#import <Social/Social.h>
#import "AppDelegate+HWShare.h"
#import <UShareUI/UShareUI.h>
#import <UMShare/UMShare.h>

@implementation HWShareItem
@end
@implementation HWShareManage

+ (void)showShareUIWithItem:(HWShareItem *)item {
    //分享的标题
    if (item.shareType == ShareTypeUIActivity) {
        [self showActivityUI:item];
    } else { // 友盟
        // 显示分享面板
        NSMutableArray *array = [NSMutableArray array];
        if (WXAppkey.length > 0) {
            [array addObjectsFromArray:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
        }
        if (QQAppkey.length > 0) {
            [array addObjectsFromArray:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
        }
        [UMSocialUIManager setPreDefinePlatforms:array];
        [UMSocialUIManager  showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            // 根据获取的platformType确定所选平台进行下一步操作
            [self shareWebPageToPlatformType:platformType andItem:item];
        }];
    }
}

+ (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType andItem:(HWShareItem *)item{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    // 判断是否有图片
    if (item.image || item.icon) { // 有图 可能是网页与图片
        messageObject.title = item.title;
        messageObject.text = item.content;
        UIImage *image = [self getImage:item];
        if (item.url) {
            //创建网页内容对象
            UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:item.title descr:item.content thumImage:image];
            //设置网页地址
            shareObject.webpageUrl = item.url;
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareObject;
        } else {
            UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:item.title descr:item.content thumImage:image];
            shareObject.shareImage = image;
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareObject;
        }
    } else { // 没图 文本分享
        if (item.title) {
            messageObject.title = item.title;
        }
        if (item.content) {
            messageObject.text = item.content;
        } else { // 如果没有内容就不分享了
            return;
        }
    }
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:[UIApplication sharedApplication].keyWindow.rootViewController completion:^(id data, NSError *error) {
        if (error) {
            HWLog(@"失败");
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                HWLog(@"成功");
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                UMSocialLogInfo(@"response data is %@",data);
                HWLog(@"失败");
            }
        }
    }];
}
+ (UIImage *)getImage:(HWShareItem *)item {
    UIImage *image;
    if (item.image) {
        image = item.image;
    } else if (item.icon.length > 0) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:item.icon]];
        image = [UIImage imageWithData:data];
    } else {
        image = [UIImage imageNamed:@"默认图片"];
    }
    return image;
}
+ (void)showActivityUI:(HWShareItem *)item {
    if (!item.title || !item.url) {return;}
    if (!item.image && !item.icon) {return;}
    NSString *textToShare = item.title;
    //分享的图片
    UIImage *imageToShare = [self getImage:item];
    //分享的url
    NSURL *urlToShare = [NSURL URLWithString:item.url];
    // 分享的图片不能为空 //在这里呢 如果想分享图片 就把图片添加进去  文字什么的通上
    NSArray *activityItems = @[textToShare, imageToShare, urlToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    // 排除（UIActivityTypeAirDrop）AirDrop 共享、(UIActivityTypePostToFacebook)Facebook //不出现在活动项目
    activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook, UIActivityTypeAirDrop];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:activityVC animated:YES completion:nil];
    // 通过block接收结果处理
    UIActivityViewControllerCompletionWithItemsHandler completionHandler = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        if (completed) {
            //分享 成功
        }else{
            //分享 取消
        }
    };
    activityVC.completionWithItemsHandler = completionHandler;
}
@end
