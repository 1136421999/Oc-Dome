//
//  HWFMDBModel.m
//  OC_FMDB面向模型开发
//
//  Created by 李含文 on 2019/4/11.
//  Copyright © 2019年 SK丿希望. All rights reserved.
//

#import "HWFMDBModel.h"
#import <objc/runtime.h>



@implementation HWFMDBModel

+ (BOOL)hw_createTableWithName:(NSString *)tableName db:(FMDatabase *)db {
    if (![db open]) {
        NSLog(@"数据库开启失败");
        return NO;
    }
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY AUTOINCREMENT", tableName];
    NSArray *keys = [self allProperties];
    for(int i = 0; i < keys.count; i++){
        NSString *key = keys[i];
        if (![key isEqualToString:@"ID"]) {
            sql = [NSString stringWithFormat:@"%@, %@ text NOT NULL", sql, key];
        }
    }
    sql = [NSString stringWithFormat:@"%@);", sql];
    BOOL result = [db executeUpdate:sql];
    return result;
}
- (BOOL)hw_insertTableWithName:(NSString *)tableName db:(FMDatabase *)db {
    if (![db open]) {
        NSLog(@"数据库开启失败");
        return NO;
    }
    NSString *sql = [NSString stringWithFormat:@"insert into '%@' (", tableName];
    NSMutableArray *keys = [[NSMutableArray alloc] initWithArray:[self allProperties]];
    [keys removeObject:@"ID"];
    NSMutableArray *temp = [NSMutableArray array];
    NSMutableArray *values = [NSMutableArray array];
    sql = [NSString stringWithFormat:@"%@%@) values(", sql, [keys componentsJoinedByString:@","]];
    for(int i = 0; i < keys.count; i++){
        NSString *key = keys[i];
        [temp addObject:@"?"];
        NSString *value = [self valueForKey:key];
        if (value) {
            [values addObject:value];
        } else {
            NSLog(@"有数据为nil");
            return NO;
        }
    }
    sql = [NSString stringWithFormat:@"%@%@", sql, [temp componentsJoinedByString:@","]];
    sql = [NSString stringWithFormat:@"%@)", sql];
    BOOL result = [db executeUpdate:sql withArgumentsInArray:values];
    return result;
}
- (BOOL)hw_updateTableWithName:(NSString *)tableName db:(FMDatabase *)db {
    if (![db open]) {
        NSLog(@"数据库开启失败");
        return NO;
    }
    NSMutableArray *keys = [[NSMutableArray alloc] initWithArray:[self allProperties]];
    BOOL result = NO;
    [keys removeObject:@"ID"];
    for(int i = 0; i < keys.count; i++){
        NSString *key = keys[i];
        NSString *sql = [NSString stringWithFormat:@"UPDATE '%@' SET %@ = '%@' WHERE id = %@",tableName,key, [self valueForKey:key], [self valueForKey:@"ID"]];
        result = [db executeUpdate:sql];
    }
    return result;
}
//查询
+ (NSArray *)hw_queryTableWithName:(NSString *)tableName db:(FMDatabase *)db {
    if (![db open]) {
        NSLog(@"数据库开启失败");
        return nil;
    }
    NSMutableArray *array = [NSMutableArray array];
    // 1.执行查询语句
    FMResultSet *resultSet = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@", tableName]];
    // 2.遍历结果
    while ([resultSet next]) {
        [array addObject:[self hw_getModel:resultSet]];
    }
    return array;
}

- (BOOL)hw_deleteTableWithName:(NSString *)tableName db:(FMDatabase *)db {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id = ", tableName];
    sql = [NSString stringWithFormat:@"%@%@", sql, [self valueForKey:@"ID"]];
    BOOL result = [db executeUpdate:sql];
    return result;
}
+ (id)hw_getModel:(FMResultSet *)resultSet {
    // 获取所有的成员变量
    id item = [[self class] new];
    
    [item setValue:[NSNumber numberWithInt:[[NSString stringWithFormat:@"%d", [resultSet intForColumn:@"id"]] intValue]] forKey:@"ID"]; // 获取表id 赋值给模型ID
    
    unsigned int outCount = 0;
    Ivar * varList = class_copyIvarList([self class], &outCount);
    for (int i = 0; i<outCount; ++i) {
        Ivar ivar = varList[i];
        //1.获取成员变量名字
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        if ([key hasPrefix:@"_"]) {
            //把 _ 去掉，读取后面的
            key = [key substringFromIndex:1];
        }
        //2.获取成员变量类型
        NSString * ivartype = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        //把包含 @\" 的去掉，如 "@\"nsstring\"";-="">
        NSString * ivarType = [ivartype stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]];
        
        NSString *ivarValueString = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:key]];
        //实例变量值
        id ivarValue = ivarValueString;
        //c - char
        if ([ivarType isEqualToString:@"c"])
            ivarValue = [NSNumber numberWithChar:[ivarValueString intValue]];
        //i - int
        else if ([ivarType isEqualToString:@"i"])
            ivarValue = [NSNumber numberWithInt:[ivarValueString intValue]];
        //s - short
        else if ([ivarType isEqualToString:@"s"])
            ivarValue = [NSNumber numberWithShort:[ivarValueString intValue]];
        //l - long
        else if ([ivarType isEqualToString:@"l"])
            ivarValue = [NSNumber numberWithLong:[ivarValueString intValue]];
        //q - long long
        else if ([ivarType isEqualToString:@"q"])
            ivarValue = [NSNumber numberWithLongLong:[ivarValueString intValue]];
        //C - unsigned char
        else if ([ivarType isEqualToString:@"C"])
            ivarValue = [NSNumber numberWithUnsignedChar:[ivarValueString intValue]];
        //I - unsigned int
        else if ([ivarType isEqualToString:@"I"])
            ivarValue = [NSNumber numberWithUnsignedInt:[ivarValueString intValue]];
        //S - unsigned short
        else if ([ivarType isEqualToString:@"S"])
            ivarValue = [NSNumber numberWithUnsignedShort:[ivarValueString intValue]];
        //L - unsigned long
        else if ([ivarType isEqualToString:@"L"])
            ivarValue = [NSNumber numberWithUnsignedLong:[ivarValueString intValue]];
        //Q - unsigned long long
        else if ([ivarType isEqualToString:@"Q"])
            ivarValue = [NSNumber numberWithUnsignedLongLong:[ivarValueString intValue]];
        //f - float
        else if ([ivarType isEqualToString:@"f"])
            ivarValue = [NSNumber numberWithFloat:[ivarValueString floatValue]];
        //d - double
        else if ([ivarType isEqualToString:@"d"])
            ivarValue = [NSNumber numberWithDouble:[ivarValueString doubleValue]];
        //B - bool or a C99 _Bool
        else if ([ivarType isEqualToString:@"B"]) {
            if ([ivarValueString isEqualToString:@"1"]) {
                ivarValue = [NSNumber numberWithBool:YES];
            } else {
                ivarValue = [NSNumber numberWithBool:NO];
            }
        }
        //v - void
        //        else if ([kvarsType isEqualToString:@"v"]) {}
        //* - char *
        //        else if ([kvarsType isEqualToString:@"*"]) {}
        //@ - id
        //        else if ([ivarType isEqualToString:@"@"]) {
        //
        //        }
        //# - Class
        //        else if ([kvarsType isEqualToString:@"#"]) {}
        //: - SEL
        //        else if ([kvarsType isEqualToString:@":"]) {}
        //@"NSArray" - array
        //        else if ([ivarType containsString:@"NSArray"]          ||
        //                 [ivarType containsString:@"NSMutableArray"]   ||
        //                 [ivarType containsString:@"NSDictionary"]     ||
        //                 [ivarType containsString:@"NSMutableDictionary"]) {
        //
        //        }
        //? - unknown type
        else {
            ivarValue = ivarValueString;
        }
        [item setValue:ivarValue forKey:key];
    }
    return item;
}

+ (FMDatabase *)getDBWithName:(NSString *)Name {
    NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath = [docuPath stringByAppendingPathComponent:Name];
    NSLog(@"数据库路径:%@",dbPath);
    //2.创建对应路径下数据库
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    return db;
}
// 获取类的所有属性
- (NSArray *)allProperties {
    unsigned int count;
    // 如果没有属性，则count为0，properties为nil
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i = 0; i < count; i++) {
        // 获取属性名称
        const char *propertyName = property_getName(properties[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        [propertiesArray addObject:name];
    }
    // 注意，这里properties是一个数组指针，是C的语法，
    // 我们需要使用free函数来释放内存，否则会造成内存泄露
    free(properties);
    return propertiesArray;
}
// 获取类的所有属性
+ (NSArray *)allProperties {
    unsigned int count;
    // 如果没有属性，则count为0，properties为nil
    objc_property_t *properties = class_copyPropertyList(self, &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i = 0; i < count; i++) {
        // 获取属性名称
        const char *propertyName = property_getName(properties[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        [propertiesArray addObject:name];
    }
    // 注意，这里properties是一个数组指针，是C的语法，
    // 我们需要使用free函数来释放内存，否则会造成内存泄露
    free(properties);
    return propertiesArray;
}
@end
