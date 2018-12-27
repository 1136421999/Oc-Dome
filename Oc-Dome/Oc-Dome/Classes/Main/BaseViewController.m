//
//  BaseViewController.m
//  kzyjsq
//
//  Created by 李含文 on 2018/12/1.
//  Copyright © 2018年 李含文. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBGColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    HWLog(@"进入%@",[self class]);
    [self switchWhiteColor];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [HUDManage dismiss];
}

- (void)dealloc {
    HWLog(@"释放%@",[self class]);
}

- (void)switchNavColor:(UIColor *)color {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage hw_imageWithColor:color] forBarMetrics:UIBarMetricsDefault];
    if (color != [UIColor whiteColor]) {
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    }
    [UIApplication sharedApplication].statusBarStyle = (color == [UIColor whiteColor] ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent);
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    //    dic[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    UIColor *setColor = (color == [UIColor whiteColor] ? [UIColor blackColor] : [UIColor whiteColor]);
    if (color == [UIColor clearColor]) {
        [self.navigationController.navigationBar setTranslucent:YES];
    } else {
        [self.navigationController.navigationBar setTranslucent:NO];
    }
    dic[NSForegroundColorAttributeName] = setColor;
    self.navigationController.navigationBar.titleTextAttributes = dic;
    self.navigationController.navigationBar.tintColor = setColor;
}


- (void)switchGradientColor {
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage hw_imageWithColor:hw_GradientColor] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    //    dic[NSFontAttributeName] = [UIFont systemFontOfSize:18];
//    [self.navigationController.navigationBar setTranslucent:NO];
//    UIColor *setColor = [UIColor whiteColor];
//    dic[NSForegroundColorAttributeName] = setColor;
//    self.navigationController.navigationBar.titleTextAttributes = dic;
//    self.navigationController.navigationBar.tintColor = setColor;
}
- (void)switchWhiteColor {
    [self switchNavColor:[UIColor whiteColor]];
}
- (void)switchBlackColor {
    [self switchNavColor:[UIColor blackColor]];
}
- (void)switchClearColor {
    [self switchNavColor:[UIColor clearColor]];
}
- (void)setBackButton:(void (^)(void))action {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [btn setImage:[UIImage hw_imageNamed:@"返回"] forState:(UIControlStateNormal)];
    btn.actionBlock = ^{
        action();
    };
    // 让返回按钮内容继续向左边偏移10
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}
@end
