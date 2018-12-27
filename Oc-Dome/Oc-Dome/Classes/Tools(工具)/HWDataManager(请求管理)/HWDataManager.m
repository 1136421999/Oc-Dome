//
//  HWDataManager.m
//  Oc-Dome
//
//  Created by 李含文 on 2018/11/30.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

#import "HWDataManager.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <CommonCrypto/CommonDigest.h>

static NSMutableArray *hw_requestTasks;

@implementation HWDataManager


+ (NSMutableArray *)allTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (hw_requestTasks == nil) {
            hw_requestTasks = [[NSMutableArray alloc] init];
        }
    });
    return hw_requestTasks;
}
// MARK: 设置请求头
+ (void)setRequestHeader:(NSDictionary *)dic {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
}
// MARK: 取消所有请求
+ (void)cancelAllRequest {
    @synchronized(self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(NSURLSessionDataTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[NSURLSessionDataTask class]]) {
                [task cancel];
            }
        }];
        [[self allTasks] removeAllObjects];
    };
}
// MARK: - 根据url取消单个请求
+ (void)cancelRequestWithURL:(NSString *)url {
    if (url == nil) {return;}
    @synchronized(self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(NSURLSessionDataTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[NSURLSessionDataTask class]]
                && [task.currentRequest.URL.absoluteString hasSuffix:url]) {
                [task cancel];
                [[self allTasks] removeObject:task];
                return;
            }
        }];
    };
}
// MARK: Get请求
+ (void)Get:(NSString *_Nullable)url
                parameters:(id _Nullable )parameters
                   success:(void (^_Nullable)(HWDataManagerItem * _Nullable item))success
                   failure:(void (^_Nullable)(HWDataManagerItem * _Nullable item))failure {
    // 创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置URL及参数
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", @"text/plain", nil];
    NSURLSessionDataTask * task = [manager GET:[self getBaseURL:url] parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self allTasks] removeObject:task];
        HWDataManagerItem * item = [self toModel:responseObject];
        item.currentRequest = task.currentRequest;
        if (item.status) {
            success(item);
        } else {
            HWLog(@"%@", task.currentRequest);
            failure(item);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HWLog(@"%@", task.currentRequest);
        [[self allTasks] removeObject:task];
        failure([self getFailureItem:(task)]);
    }];
    [[self allTasks] addObject:task];
}

+ (NSString *)getBaseURL:(NSString *)url {
    NSString *baseURL = [[NSString alloc] init];
    if (![url containsString:@"http"]) {
        baseURL = URL(url);
    } else {
        baseURL = url;
    }
    return baseURL;
}
// MARK: POST请求
+ (void)POST:(NSString *_Nullable)url
 parameters:(id _Nullable )parameters
    success:(void (^_Nullable)(HWDataManagerItem * _Nullable item))success
    failure:(void (^_Nullable)(HWDataManagerItem * _Nullable item))failure {
    // 创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置URL及参数
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", @"text/plain", nil];
    NSURLSessionDataTask * task = [manager POST:[self getBaseURL:url] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self allTasks] removeObject:task];
        HWDataManagerItem * item = [self toModel:responseObject];
        item.currentRequest = task.currentRequest;
        if (item.status) {
            success(item);
        } else {
            failure(item);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self allTasks] removeObject:task];
        failure([self getFailureItem:(task)]);
    }];
    [[self allTasks] addObject:task];
}

// 转首层模型
+ (HWDataManagerItem *)toModel:(id)responseObject {
    HWDataManagerItem *item = [HWDataManagerItem mj_objectWithKeyValues:responseObject];
    return item;
}

#pragma mark - MD5
+ (NSString *)getMD5HashWithMessage:(NSString*)message {
    const char *cStr = [message UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (unsigned)strlen(cStr), result);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

+ (void)upImageUrl:(NSString *_Nullable)url
     parameters:(id _Nullable )parameters
          images:(NSArray<UIImage *> *_Nullable)images
           name:(NSString *)name
        success:(void (^_Nullable)(HWDataManagerItem * _Nullable item))success
        failure:(void (^_Nullable)(HWDataManagerItem * _Nullable item))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", nil];
    [manager POST:[self getBaseURL:url] parameters:parameters  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //使用formData来拼接数据
        /*
         第一个参数:二进制数据 要上传的文件参数
         第二个参数:服务器规定的
         第三个参数:该文件上传到服务器以什么名称保存
         */
        for (UIImage *image in images) {
            NSData *data = UIImageJPEGRepresentation(image, 0.7);
            [formData appendPartWithFileData:data name:name fileName:@"image.png" mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self allTasks] removeObject:task];
        HWDataManagerItem * item = [self toModel:responseObject];
        item.currentRequest = task.currentRequest;
        if (item.status) {
            success(item);
        } else {
            failure(item);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self allTasks] removeObject:task];
        failure([self getFailureItem:(task)]);
    }];
}
// 失败后返回的模型
+ (HWDataManagerItem *)getFailureItem:(NSURLSessionDataTask *)task {
    HWDataManagerItem * item = [[HWDataManagerItem alloc] init];
    item.desc = @"网络请求异常";
    item.currentRequest = task.currentRequest;
    HWLog(@"%@", item.currentRequest);
    item.status = false;
    return item;
}
@end
