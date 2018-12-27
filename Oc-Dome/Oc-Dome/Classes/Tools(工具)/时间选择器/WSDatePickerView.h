//
//  WSDatePickerView.h
//  WSDatePicker
//
//  Created by iMac on 17/2/23.
//  Copyright © 2017年 zws. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+Extension.h"

typedef enum{
    DateStyleShowYearMonthDayHourMinute  = 0, // 显示年月日 时分
    DateStyleShowMonthDayHourMinute, // 显示月日 时分
    DateStyleShowYearMonthDay, // 显示年月日
    DateStyleShowMonthDay, // 显示月日
    DateStyleShowHourMinute  // 显示时分
}WSDateStyle;


@interface WSDatePickerView : UIView
@property (nonatomic, retain) NSDate *maxLimitDate;//限制最大时间（没有设置默认9999）
@property (nonatomic, retain) NSDate *minLimitDate;//限制最小时间（没有设置默认0）
+ (void)showDateWithStyle:(WSDateStyle)style action:(void(^)(NSString *dateString, NSDate *data))action;
-(instancetype)initWithDateStyle:(WSDateStyle)datePickerStyle CompleteBlock:(void(^)(NSString *dateString, NSDate *data, WSDateStyle style))completeBlock;
-(void)show;
@end

