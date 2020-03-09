//
//  NSMutableAttributedString+HWCategry.m
//  OC富文本
//
//  Created by 李含文 on 2019/1/7.
//  Copyright © 2019年 SK丿希望. All rights reserved.
//

#import "NSMutableAttributedString+HWCategry.h"

@implementation NSMutableAttributedString (HWCategry)
// MARK: 修改颜色
- (NSMutableAttributedString *)hw_color:(UIColor *)color {
    [self hw_color:color range:NSMakeRange(0, self.length)];
    return self;
}
- (NSMutableAttributedString * _Nonnull (^)(UIColor * _Nonnull))hw_color {
    return ^(UIColor *color) {
        return [self hw_color:color];
//        return self;
    };
}
- (NSMutableAttributedString *)hw_color:(UIColor *)color range:(NSRange)range {
    [self addAttribute:NSForegroundColorAttributeName value:color range:[self chackRange:range]];
    return self;
}
// MARK: 修改字体大小
- (NSMutableAttributedString *)hw_font:(CGFloat)font {
    [self hw_font:font range:NSMakeRange(0, self.length)];
    return self;
}
- (NSMutableAttributedString *)hw_font:(CGFloat)font range:(NSRange)range {
    [self addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:[self chackRange:range]];
    return self;
}
// MARK: 修改背景颜色
- (NSMutableAttributedString *)hw_backgroundColor:(UIColor *)color {
    [self hw_backgroundColor:color range:NSMakeRange(0, self.length)];
    return self;
}
- (NSMutableAttributedString *)hw_backgroundColor:(UIColor *)color range:(NSRange)range {
    [self addAttribute:NSBackgroundColorAttributeName value:color range:[self chackRange:range]];
    return self;
}

// MARK: 删除线
- (NSMutableAttributedString *)hw_deleteLine {
    [self hw_deleteLineWithRange:NSMakeRange(0, self.length)];
    return self;
}
- (NSMutableAttributedString *)hw_deleteLineWithRange:(NSRange)range {
//    NSUnderlineStyleNone 不设置删除线
//    NSUnderlineStyleSingle 设置删除线为细单实线
//    NSUnderlineStyleThick 设置删除线为粗单实线
//    NSUnderlineStyleDouble 设置删除线为细双实线
    [self addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:[self chackRange:range]];
    return self;
}
- (NSMutableAttributedString *)hw_deleteLineWithColor:(UIColor *)color {
    [self addAttribute:NSStrikethroughColorAttributeName value:color range:NSMakeRange(0, self.length)];
    return self;
}
// MARK: 下划线
- (NSMutableAttributedString *)hw_buttomLine {
    [self hw_buttomLineWithRange:NSMakeRange(0, self.length)];
    return self;
}
- (NSMutableAttributedString *)hw_buttomLineWithRange:(NSRange)range {
    [self addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:[self chackRange:range]];
    return self;
}
- (NSMutableAttributedString *)hw_buttomLineWithColor:(UIColor *)color {
    [self addAttribute:NSUnderlineColorAttributeName value:color range:NSMakeRange(0, self.length)];
    return self;
}

- (NSMutableAttributedString *)hw_addAttributed:(NSAttributedString *)attr {
    NSString *str = [NSString stringWithFormat:@"%@%@", self.string, attr.string];
    return [[NSMutableAttributedString alloc] initWithString:str];
}

// MARK: 图文
- (NSMutableAttributedString *)hw_insertImage:(NSString *)imageName bounds:(CGRect)bounds atIndex:(NSInteger)index {
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = [UIImage imageNamed:imageName];
    // 设置图片大小
    attch.bounds = bounds;
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    if (index < 0) {
        index = 0;
    } else if (index > self.length) {
        index = self.length;
    }
    [self insertAttributedString:string atIndex:index];
    return self;
}

- (NSMutableAttributedString *)hw_addImage:(NSString *)imageName bounds:(CGRect)bounds {
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = [UIImage imageNamed:imageName];
    // 设置图片大小
    attch.bounds = bounds;
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [self appendAttributedString:string];
    return self;
}
// MARK: - 校验防止越界
- (NSRange)chackRange:(NSRange)range {
    NSInteger location = range.location;
    NSInteger length = range.length;
    if (location < 0) {
        location = 0;
    }
    if (location> self.length) {
        location = self.length;
    }
    if (length < 0) {
        length = 0;
    }
    if (length > self.length) {
        length = self.length;
    }
    return NSMakeRange(location, length);
}
@end
// NSFontAttributeName                设置字体属性，默认值：字体：Helvetica(Neue) 字号：12
// NSForegroundColorAttributeNam      设置字体颜色，取值为 UIColor对象，默认值为黑色
// NSBackgroundColorAttributeName     设置字体所在区域背景颜色，取值为 UIColor对象，默认值为nil, 透明色
// NSLigatureAttributeName            设置连体属性，取值为NSNumber 对象(整数)，0 表示没有连体字符，1 表示使用默认的连体字符
// NSKernAttributeName                设定字符间距，取值为 NSNumber 对象（整数），正值间距加宽，负值间距变窄
// NSStrikethroughStyleAttributeName  设置删除线，取值为 NSNumber 对象（整数）
// NSStrikethroughColorAttributeName  设置删除线颜色，取值为 UIColor 对象，默认值为黑色
// NSUnderlineStyleAttributeName      设置下划线，取值为 NSNumber 对象（整数），枚举常量 NSUnderlineStyle中的值，与删除线类似
// NSUnderlineColorAttributeName      设置下划线颜色，取值为 UIColor 对象，默认值为黑色
// NSStrokeWidthAttributeName         设置笔画宽度，取值为 NSNumber 对象（整数），负值填充效果，正值中空效果
// NSStrokeColorAttributeName         填充部分颜色，不是字体颜色，取值为 UIColor 对象
// NSShadowAttributeName              设置阴影属性，取值为 NSShadow 对象
// NSTextEffectAttributeName          设置文本特殊效果，取值为 NSString 对象，目前只有图版印刷效果可用：
// NSBaselineOffsetAttributeName      设置基线偏移值，取值为 NSNumber （float）,正值上偏，负值下偏
// NSObliquenessAttributeName         设置字形倾斜度，取值为 NSNumber （float）,正值右倾，负值左倾
// NSExpansionAttributeName           设置文本横向拉伸属性，取值为 NSNumber （float）,正值横向拉伸文本，负值横向压缩文本
// NSWritingDirectionAttributeName    设置文字书写方向，从左向右书写或者从右向左书写
// NSVerticalGlyphFormAttributeName   设置文字排版方向，取值为 NSNumber 对象(整数)，0 表示横排文本，1 表示竖排文本
// NSLinkAttributeName                设置链接属性，点击后调用浏览器打开指定URL地址
// NSAttachmentAttributeName          设置文本附件,取值为NSTextAttachment对象,常用于文字图片混排
// NSParagraphStyleAttributeName      设置文本段落排版格式，取值为 NSParagraphStyle 对象

