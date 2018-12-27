//
//  MyTabBarController.m
//  Oc-Dome
//
//  Created by 李含文 on 2018/11/12.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

#import "MyTabBarController.h"

@interface MyTabBarController ()

@end

@implementation MyTabBarController


+ (void)load {
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    NSMutableDictionary *defaultdic = [[NSMutableDictionary alloc] init];
    // 设置默认颜色
    defaultdic[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [tabBarItem setTitleTextAttributes:defaultdic forState:UIControlStateNormal];
    
    NSMutableDictionary *selecteddic = [[NSMutableDictionary alloc] init];
    // 设置选中颜色
    selecteddic[NSForegroundColorAttributeName] = [UIColor redColor];
    [tabBarItem setTitleTextAttributes:selecteddic forState:UIControlStateSelected];
    // 设置字体大小
    NSMutableDictionary *fontdic = [[NSMutableDictionary alloc] init];
    fontdic[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    [tabBarItem setTitleTextAttributes:fontdic forState:UIControlStateNormal];
    // 设置tab背景颜色
    UITabBar *tab = [UITabBar appearance];
    [tab setTranslucent:NO];
    [tab setBackgroundColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabBarItem];
}

#pragma mark - 设置子控制器
- (void)setTabBarItem {
    [self setChildControllerWithTitle:@"首页" VCName:@"HomeViewController"];
    [self setChildControllerWithTitle:@"我的" VCName:@"UIViewController"];
}

- (void)setChildControllerWithTitle:(NSString *)title VCName:(NSString *)VCName {
    UIViewController *vc = [[NSClassFromString(VCName) alloc] init];
    vc.tabBarItem.title = title;
    vc.title = title;
    vc.tabBarItem.image = [UIImage hw_imageNamed:[NSString stringWithFormat:@"%@未选中", title]];
    vc.tabBarItem.selectedImage = [UIImage hw_imageNamed:[NSString stringWithFormat:@"%@选中", title]];
    MyNavigationController *nav = [[MyNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
