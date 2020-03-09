//
//  NSDate+HWCategory.m
//  kzyjsq
//
//  Created by 李含文 on 2019/1/9.
//  Copyright © 2019年 李含文. All rights reserved.
//

#import "NSDate+HWCategory.h"


#define NELocalizedString(key, comment) NSLocalizedStringFromTableInBundle(key, @"NSDate_HWCategory", [NSBundle bundleForClass:[NSECoreConstants class]], comment)

@implementation NSDate (HWCategory)

/// 获取当前时间戳
+ (NSString *)hw_getCurrentTimestamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    return timeSp;
}

// 获取当前的时间
+ (NSString*)hw_getCurrentTimesWithFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:format];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString =  %@",currentTimeString);
    return currentTimeString;
}

+ (NSDate*)dateWithString:(NSString*)dateString{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *formatterDate = [inputFormatter dateFromString:dateString];
    return formatterDate;
}

+ (NSDate*)dateWithString:(NSString*)dateString withFormat:(NSString *)format{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSDate *formatterDate = [inputFormatter dateFromString:dateString];
    return formatterDate;
}
// 获取年
- (NSInteger)hw_getYear {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents =
    [gregorian components:(NSCalendarUnitYear) fromDate:self];
    NSInteger year = [weekdayComponents year];
    return year;
}
// 获取月
- (NSInteger)hw_getMonth {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents =
    [gregorian components:(NSCalendarUnitMonth) fromDate:self];
    NSInteger month = [weekdayComponents month];
    return month;
}
// 日
- (NSInteger)hw_getDay {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents =
    [gregorian components:(NSCalendarUnitDay) fromDate:self];
    NSInteger day = [weekdayComponents day];
    return day;
}
//获取指定日期的星期
- (NSInteger)hw_getWeek {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents =
    [gregorian components:(NSCalendarUnitWeekday) fromDate:self];
    NSInteger week = [weekdayComponents weekday];
    return week;
}
//获取指定日期的时
- (NSInteger)hw_getHour {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents =
    [gregorian components:(NSCalendarUnitHour) fromDate:self];
    NSInteger Hour = [weekdayComponents hour];
    return Hour;
}
//获取指定日期的分
- (NSInteger)getMinute {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents =
    [gregorian components:(NSCalendarUnitMinute) fromDate:self];
    NSInteger minute = [weekdayComponents minute];
    return minute;
}
//获取指定日期的秒
- (NSInteger)getSecond {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents =
    [gregorian components:(NSCalendarUnitSecond) fromDate:self];
    NSInteger second = [weekdayComponents second];
    return second;
}
// 判断是不是今天
- (BOOL)hw_isToday {
    NSDate * now = [NSDate date];
    if ([self hw_getYear]==[now hw_getYear] &&
        [self hw_getMonth]==[now hw_getMonth] &&
        [self hw_getDay]==[now hw_getDay]) {
        return YES;
    }
    return NO;
}

// 判断是不是昨天
- (BOOL)hw_isYesterday {
    NSDate * dd = [NSDate dateWithString:[NSString stringWithFormat:@"%4d-%2d-%2d 00:00",
                                          (int)[[NSDate date] hw_getYear],
                                          (int)[[NSDate date] hw_getMonth],
                                          (int)[[NSDate date] hw_getDay]]
                              withFormat:@"yyyy-MM-dd HH:mm"];
    NSTimeInterval yesterday = [dd timeIntervalSince1970];
    NSTimeInterval todaybefor = yesterday - (3600*24);
    NSTimeInterval selfTime = [self timeIntervalSince1970];
    if (todaybefor <= selfTime && selfTime < yesterday) {
        return YES;
    }
    return NO;
}
// 判断是不是同一天
- (BOOL)hw_isSameDay:(NSDate*)date {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:self];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date];
    return [comp1 day]   == [comp2 day] && [comp1 month] == [comp2 month] && [comp1 year]  == [comp2 year];
}

// MARK: - 格式刷
- (NSString*)hw_toStringWithFormat:(NSString*)format{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:format];
    NSString *newDateString = [outputFormatter stringFromDate:self];
    return newDateString;
}

// MARK: - 获取过去多少时间
- (NSString*)hw_getPastTimeString {
    NSTimeInterval selftime = [self timeIntervalSince1970];
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSDate * d = [NSDate dateWithString:[NSString stringWithFormat:@"%4d-%2d-%2d 00:00",
                                         (int)[[NSDate date] hw_getYear],
                                         (int)[[NSDate date] hw_getMonth],
                                         (int)[[NSDate date] hw_getDay]]
                             withFormat:@"yyyy-MM-dd HH:mm"];
    NSTimeInterval yesterday = [d timeIntervalSince1970];
    NSTimeInterval todaybefor = yesterday - (3600*24);
    NSTimeInterval daqiantian = todaybefor - (3600*24);
    NSString *str = nil;
    NSTimeInterval distime = now - selftime;
    if (selftime > now) {
        str = @"将来";
    } else if (selftime <= now) {
        if (distime < 5 * 60) {
            str = @"刚刚";
        } else if (distime > 25 * 60  && distime < 35*60) {
            return @"半小时前";
        } else if (distime < 60 * 60) {
            int m = (int)distime/60;
            if (m == 1) {
                str = [NSString stringWithFormat:@"%d分钟前", m];
            } else {
                str = [NSString stringWithFormat:@"%d分钟前", m];
            }
        } else  {
            if (selftime > yesterday) {
                str = [self hw_toStringWithFormat:@"HH:mm"];
            } else if (selftime <= yesterday && selftime > todaybefor) {
                str = @"昨天";
            } else if (selftime <= todaybefor && selftime > daqiantian) {
                str = @"前天";
            } else if (yesterday - selftime <= 60 * 60 * 24 * 15){
                str = [NSString stringWithFormat:@"%d天前", (int)( (yesterday - selftime) / (60 * 60 * 24) + 1 )];
            } else if ([[NSDate date] hw_getYear] != [self hw_getYear]) {
                str = [self hw_toStringWithFormat:@"yy-MM-dd"];
            } else {
                str = [self hw_toStringWithFormat:@"MM-dd"];
            }
        }
    }
    return str;
}

// MARK: - 获取当月的天数
+ (NSInteger)hw_getCurrentMonthDays {
    return [[NSDate date] hw_getMonthDays];
}
- (NSInteger)hw_getMonthDays {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    NSUInteger numberOfDaysInMonth = range.length;
    return [[NSString stringWithFormat:@"%lu", (unsigned long)numberOfDaysInMonth] integerValue];
}
// MARK: - 获取对应年月的天数
+ (NSInteger)hw_getDaysWithYear:(NSInteger)year month:(NSInteger)month {
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDate *date = [self hw_toDateWithYear:year month:month];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSUInteger numberOfDaysInMonth = range.length;
    return [[NSString stringWithFormat:@"%lu", (unsigned long)numberOfDaysInMonth] integerValue];
}
// MARK: - 年月转NSDate
+ (NSDate *)hw_toDateWithYear:(NSInteger)year month:(NSInteger)month {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSCalendar * calendar = [NSCalendar currentCalendar];
    comps.year = year;
    comps.month = month;
    NSDate *date = [calendar dateFromComponents:comps];
    return date;
}
// MARK: - 年月日转NSDate
+ (NSDate *)hw_toDateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSCalendar * calendar = [NSCalendar currentCalendar];
    comps.year = year;
    comps.month = month;
    comps.day = day;
    NSDate *date = [calendar dateFromComponents:comps];
    return date;
}
+ (NSArray<NSDate *> *)hw_getCurrentMonthDateArray {
    NSMutableArray *array = [NSMutableArray array];
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSDate *date = [NSDate date];
    comps.year = [date hw_getYear];
    comps.month = [date hw_getMonth];
    comps.hour = 20; // 设置时间避免12点以前提前一天
    for(int i = 1; i <= [self hw_getCurrentMonthDays]; i++){
        comps.day = i;
        NSDate *date = [calendar dateFromComponents:comps];
        [array addObject:date];
    }
    return array;
}
- (NSArray<NSDate *> *)hw_getDateArray {
    NSMutableArray *array = [NSMutableArray array];
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSDate *date = self;
    comps.year = [date hw_getYear];
    comps.month = [date hw_getMonth];
    comps.hour = 20; // 设置时间避免12点以前提前一天
    for(int i = 1; i <= [self hw_getMonthDays]; i++){
        comps.day = i;
        NSDate *date = [calendar dateFromComponents:comps];
        [array addObject:date];
    }
    return array;
}
// MARK: - 获取当月周数
+ (NSInteger)hw_getCurrentMonthWeeks {
    return [[NSDate date] hw_getWeeks];
}
// MARK: - 获取周数
- (NSInteger)hw_getWeeks {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
    NSUInteger weeks = range.length;
    return [[NSString stringWithFormat:@"%lu", (unsigned long)weeks] integerValue];
}
// MARK: - 获取今天是当月的第几周
+ (NSInteger)hw_getCurrentDayWeeks {
    return [[NSDate date] hw_getDayWeeks];
}
// MARK: - 获取当前日期是当月的第几周
- (NSInteger)hw_getDayWeeks {
    NSInteger week = 0;
    //    NSDateComponents*comps;
    //    NSCalendar *calendar = [NSCalendar currentCalendar];
    //    comps =[calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit)
    //                       fromDate:self];
    //    NSInteger week = [comps weekdayOrdinal]; // 这个月的第几周
    //    NSDate *currentDate = self;
    //    NSInteger week = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitMonth forDate:currentDate];
    NSArray *dateArray = [self hw_getDateArray];
    if (dateArray.count > 0) {
        NSDate *fistdate = [self hw_getDateArray][0];
        NSInteger fistday = [fistdate hw_getWeekday];
        NSInteger cday = [self hw_getDay];
        NSInteger num = cday + fistday - 2;
        week = num/7;
    }
    return week;
}
// MARK: - 获取当天是星期几 (7为星期天)
+ (NSInteger)hw_getCurrentDayWeekday {
    return [[NSDate date] hw_getWeekday];
}
// MARK: 获取星期几 (7为星期天)
- (NSInteger)hw_getWeekday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Beijing"];
    [calendar setTimeZone: timeZone];
    NSDate *date = self;
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    NSInteger num = theComponents.weekday-1;
    if (num == 0) {
        num = 7;
    }
    return num;
}
// MARK: - 获取当天是星期几
+ (NSString *)hw_getCurrentDayWeekdayName {
    NSArray *weekdays = @[@"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", @"星期天"];
    NSInteger index = [self hw_getCurrentDayWeekday];
    return weekdays[index-1];
}
// MARK:  获取星期几
- (NSString *)hw_getWeekdayName {
    //    NSArray *weekdays = @[@"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", @"星期天"];
    NSArray *weekdays = @[@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日"];
    NSInteger index = [self hw_getWeekday];
    return weekdays[index-1];
}
// MARK: - 获取当天农历
+ (NSString *)hw_getCurrentDayLunarCalendar {
    return [[NSDate date] hw_getLunarCalendar];
}
// MARK: 获取农历
- (NSString *)hw_getLunarCalendar {
    static NSArray *dayArray;
    static NSArray *monthArray;
    static dispatch_once_t once;
    NSString *lunarCalendar = @"";
    dispatch_once(&once, ^{
        dayArray  = @[ @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",@"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",@"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"];
        
        monthArray = @[@"正月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"冬月",@"腊月"];
    });
    //获取农历
#ifdef __IPHONE_8_0
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:self];
#else
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:self];
#endif
    lunarCalendar = dayArray[localeComp.day-1];
    if (localeComp.day-1 == 0) {
        lunarCalendar = monthArray[localeComp.month-1];
    }
    return lunarCalendar;
}
// MARK: - 获取当月第一天
+ (NSDate *)hw_getCurrentMonthFirstDay {
    NSDate *newDate = [NSDate date];
    double interval = 0;
    NSDate *beginDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    /*
     (当 firstWeekday 被指定为其它值时(即 <> 1)时，假设firstWeekday 被指定为星期一(即 = 2)，那么:)fromDate 传入的参数是星期一，则函数返回 1
     fromDate 传入的参数是星期二，则函数返回 2
     fromDate 传入的参数是星期日，则函数返回 7
     */
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        return beginDate;
    }else {
        return nil;
    }
}
// MARK: - 获取当月最后一天
+ (NSDate *)hw_getCurrentMonthLastDay {
    NSDate *newDate = [NSDate date];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
        return endDate;
    }else {
        return nil;
    }
}
// MARK: - 获取当月第一天是星期几 (7为星期天)
+ (NSInteger)hw_getCurrentMonthFirstDayWeekday {
    NSDate *date = [self hw_getCurrentMonthFirstDay];
    return [date hw_getWeekday];
}
// MARK: - 获取当月最后一天是星期几 (7为星期天)
+ (NSInteger)hw_getCurrentMonthLastDayWeekday {
    NSDate *date = [self hw_getCurrentMonthLastDay];
    return [date hw_getWeekday];
}
@end
