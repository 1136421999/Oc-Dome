//
//  FMDBItem.h
//  OC_FMDB面向模型开发
//
//  Created by 李含文 on 2019/4/11.
//  Copyright © 2019年 SK丿希望. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HWFMDBModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMDBItem : HWFMDBModel

/** <#注释#> */
@property(nonatomic, strong) NSString *name;

/** <#注释#> */
@property(nonatomic, assign) NSInteger age;

@end

NS_ASSUME_NONNULL_END
