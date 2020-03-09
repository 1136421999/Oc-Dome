//
//  UILabelClickViewController.m
//  Oc-Dome
//
//  Created by 李含文 on 2019/4/13.
//  Copyright © 2019年 东莞市三心网络科技有限公司. All rights reserved.
//

#import "UILabelClickViewController.h"

#import "HWAttributesLabel.h"


@interface UILabelClickViewController ()
/** <#注释#> */
@property(nonatomic, strong) HWAttributesLabel *label;

@end

@implementation UILabelClickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBGColor];
    NSString *temp = @"我已经阅读并同意《注册协议》";
    self.label = [[HWAttributesLabel alloc] initWithFrame:CGRectMake(15, 50, HWScreenW-30, 30)];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:temp];
    
    NSString *content = @"《注册协议》";
    NSRange range = [temp rangeOfString:content];
    
    NSLog(@"range%@",NSStringFromRange(range));
    [attrStr addAttribute:NSLinkAttributeName
                    value:content
                    range: range];
    
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:20]
                    range:NSMakeRange(0, attrStr.length)];
    [self.label hw_setAttributesText:attrStr actionText:content action:^{
        HWLog(@"点击了注册协议");
    }];
    [self.view addSubview:self.label];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
