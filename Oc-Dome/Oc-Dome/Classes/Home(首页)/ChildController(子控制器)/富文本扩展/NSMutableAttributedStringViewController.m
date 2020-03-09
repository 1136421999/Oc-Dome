//
//  NSMutableAttributedStringViewController.m
//  Oc-Dome
//
//  Created by 李含文 on 2019/1/14.
//  Copyright © 2019年 东莞市三心网络科技有限公司. All rights reserved.
//

#import "NSMutableAttributedStringViewController.h"

@interface NSMutableAttributedStringViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label_1;
@property (weak, nonatomic) IBOutlet UILabel *label_2;
@property (weak, nonatomic) IBOutlet UILabel *label_3;
@property (weak, nonatomic) IBOutlet UILabel *label_4;
@property (weak, nonatomic) IBOutlet UILabel *label_5;
@end

@implementation NSMutableAttributedStringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableAttributedString *attr = [@"我不要种田 我要当老板" hw_toAttributed];
    /// 设置文字颜色
    [attr hw_color:[UIColor redColor]];
    self.label_1.attributedText = attr;
    /// 设置文字大小
    [attr hw_font:20];
    self.label_2.attributedText = attr;
    /// 添加背景颜色
    [attr hw_backgroundColor:[UIColor yellowColor]];
    self.label_3.attributedText = attr;
    /// 添加删除线
    [attr hw_deleteLineWithRange:NSMakeRange(-1, 50)];
    self.label_4.attributedText = attr;
    /// 添加下划线
    [attr hw_buttomLine];
    /// 添加图片单最后
    [attr hw_addImage:@"圆圈选中" bounds:CGRectMake(0, -3, 20, 20)];
    /// 插入图片
    [attr hw_insertImage:@"圆圈选中" bounds:CGRectMake(0, -3, 20, 20) atIndex:2];
    /// 修改删除线颜色
    [attr hw_deleteLineWithColor:[UIColor blueColor]];
    /// 修改下划线颜色
    [attr hw_buttomLineWithColor:[UIColor blackColor]];
//    NSRangePointer *
//    NSDictionary; *dic = [attr attributesAtIndex:0 effectiveRange:NSMakeRange(0, attr.string.length)];
    self.label_5.attributedText = attr;
}

@end
