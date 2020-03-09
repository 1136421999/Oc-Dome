//
//  NSDate+HWCategory.h
//  kzyjsq
//
//  Created by 李含文 on 2019/1/9.
//  Copyright © 2019年 李含文. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (HWCategory)
/// 获取当前时间戳
+ (NSString *)hw_getCurrentTimestamp;
/// 获取当前时间
+ (NSString*)hw_getCurrentTimesWithFormat:(NSString *)format;

// 获取年
- (NSInteger)hw_getYear;
// 获取月
- (NSInteger)hw_getMonth;
// 日
- (NSInteger)hw_getDay;
//获取指定日期的星期
- (NSInteger)hw_getWeek;
//获取指定日期的时
- (NSInteger)hw_getHour;
//获取指定日期的分
- (NSInteger)getMinute;
//获取指定日期的秒
- (NSInteger)getSecond;
// 判断是不是今天
- (BOOL)hw_isToday;
// 判断是不是昨天
- (BOOL)hw_isYesterday;
// 判断是不是同一天
- (BOOL)hw_isSameDay:(NSDate*)date;
// MARK: - 格式刷
- (NSString*)hw_toStringWithFormat:(NSString*)format;
// MARK: - 获取过去了多少时间
- (NSString*)hw_getPastTimeString;

/** 获取当月的天数 */
+ (NSInteger)hw_getCurrentMonthDays;
/** 获取日期对应月份的天数 */
- (NSInteger)hw_getMonthDays;
/** 获取对应年月的天数 */
+ (NSInteger)hw_getDaysWithYear:(NSInteger)year month:(NSInteger)month;
/** 年月转NSDate */
+ (NSDate *)hw_toDateWithYear:(NSInteger)year month:(NSInteger)month;

+ (NSDate *)hw_toDateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

/** 获取当月的所有日期 */
+ (NSArray<NSDate *> *)hw_getCurrentMonthDateArray;
/** 获取日期对应所有日期 */
- (NSArray<NSDate *> *)hw_getDateArray;

/** 获取当月周数 */
+ (NSInteger)hw_getCurrentMonthWeeks;
/** 获取日期对应周数 */
- (NSInteger)hw_getWeeks;

// MARK: - 获取当天日期在当月是第几周
+ (NSInteger)hw_getCurrentDayWeeks;
// MARK: - 获取当前日期在当月周数
- (NSInteger)hw_getDayWeeks;

/** 获取当天是星期几 (7为星期天) */
+ (NSInteger)hw_getCurrentDayWeekday;
/** 获取日期对应星期几 (7为星期天) */
- (NSInteger)hw_getWeekday;

/** 获取当天是星期几 */
+ (NSString *)hw_getCurrentDayWeekdayName;
/** 获取星期几 */
- (NSString *)hw_getWeekdayName;

/** 获取当天农历 */
+ (NSString *)hw_getCurrentDayLunarCalendar;
/** 获取日期对应农历 */
- (NSString *)hw_getLunarCalendar;

/** 获取当月第一天 */
+ (NSDate *)hw_getCurrentMonthFirstDay;
/** 获取当月最后一天 */
+ (NSDate *)hw_getCurrentMonthLastDay;
/** 获取当月第一天是星期几 (7为星期天) */
+ (NSInteger)hw_getCurrentMonthFirstDayWeekday;
/**  获取当月最后一天是星期几 (7为星期天) */
+ (NSInteger)hw_getCurrentMonthLastDayWeekday;
@end

NS_ASSUME_NONNULL_END
