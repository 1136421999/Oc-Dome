//
//  HWDataManagerItem.h
//  Oc-Dome
//
//  Created by 李含文 on 2018/11/30.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HWDataManagerItem : NSObject

@property (nonatomic,copy) NSString *desc; //描述

@property (nonatomic,copy) NSString *flag; //描述

@property (nonatomic,strong) id data;

@property (nonatomic,assign) BOOL status; //!< NO 失败  yes 成功

@property (nullable,copy) NSURLRequest *currentRequest;

@end

NS_ASSUME_NONNULL_END
