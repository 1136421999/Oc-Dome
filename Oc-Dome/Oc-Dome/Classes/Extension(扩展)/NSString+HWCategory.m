//
//  NSString+HWCategory.m
//  Oc-Dome
//
//  Created by 李含文 on 2018/11/29.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

#import "NSString+HWCategory.h"

@implementation NSString (HWCategory)
- (NSString *)hw_Dataformatting:(NSString *)fomrdata{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:fomrdata];
//    formatter.timeZone = [NSTimeZone systemTimeZone]; 
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[self integerValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

#pragma mark - 去掉小数点之后的0
- (NSString*)hw_removeFloatAllZero {
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(self.floatValue)];
    return outNumber;
}
- (NSArray *)hw_segmentation {
    return [self hw_segmentationWithSub:@","];
}
- (NSArray *)hw_segmentationWithSub:(NSString *)sub {
    if (self.length > 0) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSString *str in [self componentsSeparatedByString:sub]) {
            if (str.length > 0) {
                [array addObject:str];
            }
        }
        return array;
    }
    return nil;
}
- (UIColor *)hw_hexColor {
    return [UIColor hw_colorWithHex:self];
}

/**
 获取文字尺寸
 @param font 文字大小
 @param maxSize 支持的最大尺寸
 @return 尺寸
 */
- (CGSize)hw_getSizeWithFont:(UIFont *)font addMaxSize:(CGSize)maxSize {
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil] context:nil].size;
}
- (CGFloat)hw_getHeightWithFont:(CGFloat)font addMaxWidth:(CGFloat)maxWidth {
    return [self hw_getSizeWithFont:[UIFont systemFontOfSize:font] addMaxSize:CGSizeMake(maxWidth, MAXFLOAT)].height;
}
- (CGFloat)hw_getWidthWithFont:(CGFloat)font addMaxHeight:(CGFloat)maxHeight {
    return [self hw_getSizeWithFont:[UIFont systemFontOfSize:font] addMaxSize:CGSizeMake(MAXFLOAT, maxHeight)].width;
}
- (NSMutableAttributedString *)hw_toAttributed {
    return [[NSMutableAttributedString alloc] initWithString:self];
}
@end
