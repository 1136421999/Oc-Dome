//
//  MyNavigationController.m
//  Oc-Dome
//
//  Created by 李含文 on 2018/11/29.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

#import "MyNavigationController.h"

@interface MyNavigationController ()

@end

@implementation MyNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *colors = [NSMutableArray array];
    [colors addObject:[UIColor whiteColor]];
//    [colors addObject:[UIColor hw_colorWithHex:@"3333333"]];
    [colors addObject:[UIColor blackColor]];
    self.navigationBar.barTintColor =  [UIColor hw_colorWithGradientStyle:(HWGradientStyleLeftToRight) withFrame:[UIScreen mainScreen].bounds andColors:colors];//[UIColor blackColor];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    dic[NSForegroundColorAttributeName] = [UIColor whiteColor];
    self.navigationBar.titleTextAttributes = dic;
}
/*
字符属性

字符属性可以应用于 attributed string 的文本中。

NSString *const NSFontAttributeName;(字体)

NSString *const NSParagraphStyleAttributeName;(段落)

NSString *const NSForegroundColorAttributeName;(字体颜色)

NSString *const NSBackgroundColorAttributeName;(字体背景色)

NSString *const NSLigatureAttributeName;(连字符)

NSString *const NSKernAttributeName;(字间距)

NSString *const NSStrikethroughStyleAttributeName;(删除线)

NSString *const NSUnderlineStyleAttributeName;(下划线)

NSString *const NSStrokeColorAttributeName;(边线颜色)

NSString *const NSStrokeWidthAttributeName;(边线宽度)

NSString *const NSShadowAttributeName;(阴影)(横竖排版)

NSString *const NSVerticalGlyphFormAttributeName;

*/
@end
