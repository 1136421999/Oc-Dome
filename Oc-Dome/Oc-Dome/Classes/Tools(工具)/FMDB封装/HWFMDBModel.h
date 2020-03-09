//
//  HWFMDBModel.h
//  OC_FMDB面向模型开发
//
//  Created by 李含文 on 2019/4/11.
//  Copyright © 2019年 SK丿希望. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface HWFMDBModel : NSObject
/** 注意:添加必须大写 用于记录添加数据id */
@property (nonatomic, assign) NSInteger ID;

/**
 创建表

 @param tableName 表名
 @param db DB
 @return 是否创建成功
 */
+ (BOOL)hw_createTableWithName:(NSString *)tableName db:(FMDatabase *)db;
/**
 插入数据
 
 @param tableName 表名
 @param db DB
 @return 是否插入成功
 */
- (BOOL)hw_insertTableWithName:(NSString *)tableName db:(FMDatabase *)db;
/**
 删除数据
 
 @param tableName 表名
 @param db DB
 @return 是否删除成功
 */
- (BOOL)hw_deleteTableWithName:(NSString *)tableName db:(FMDatabase *)db;
/**
 更新数据
 
 @param tableName 表名
 @param db DB
 @return 是否更新成功
 */
- (BOOL)hw_updateTableWithName:(NSString *)tableName db:(FMDatabase *)db;
/**
 查询数据
 
 @param tableName 表名
 @param db DB
 @return 模型数组
 */
+ (NSArray *)hw_queryTableWithName:(NSString *)tableName db:(FMDatabase *)db;
@end

NS_ASSUME_NONNULL_END
