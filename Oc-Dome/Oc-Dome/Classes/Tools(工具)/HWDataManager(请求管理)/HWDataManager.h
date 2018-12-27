//
//  HWDataManager.h
//  Oc-Dome
//
//  Created by 李含文 on 2018/11/30.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HWDataManagerItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface HWDataManager : NSObject
/** 取消所有请求 */
+ (void)cancelAllRequest;
/* 根据url取消单个请求 */
+ (void)cancelRequestWithURL:(NSString *)url;
/* 设置请求头 */
+ (void)setRequestHeader:(NSDictionary *)dic;

/**
 Get请求

 @param url url
 @param parameters 参数
 @param success 成功回调
 @param failure 失败b回调
 */
+ (void)Get:(NSString *_Nullable)url
 parameters:(id _Nullable )parameters
    success:(void (^_Nullable)(HWDataManagerItem * _Nullable item))success
    failure:(void (^_Nullable)(HWDataManagerItem * _Nullable item))failure;
/**
 POST请求
 
 @param url url
 @param parameters 参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)POST:(NSString *_Nullable)url
  parameters:(id _Nullable )parameters
     success:(void (^_Nullable)(HWDataManagerItem * _Nullable item))success
     failure:(void (^_Nullable)(HWDataManagerItem * _Nullable item))failure;

/**
 上传图片

 @param url url
 @param parameters 参数
 @param images 图片数组
 @param name 上传的文件名
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)upImageUrl:(NSString *_Nullable)url
     parameters:(id _Nullable)parameters
          images:(NSArray<UIImage *> *_Nullable)images
           name:(NSString *)name
        success:(void (^_Nullable)(HWDataManagerItem * _Nullable item))success
        failure:(void (^_Nullable)(HWDataManagerItem * _Nullable item))failure;
/**
 md5加密

 @param message 加密串
 @return 加密后的串
 */
+ (NSString *)getMD5HashWithMessage:(NSString*)message;
@end

NS_ASSUME_NONNULL_END
