//
//  HWSpeechManage.h
//  Oc-Dome
//
//  Created by 李含文 on 2019/4/13.
//  Copyright © 2019年 东莞市三心网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HWSpeechManage : NSObject
//播放模型单例
+ (instancetype)sharedManage;
/** 请说出你的故事 */
@property (nonatomic,copy) NSString *content;

- (void)start;
@end

NS_ASSUME_NONNULL_END
