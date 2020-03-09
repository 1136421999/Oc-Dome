//
//  MyTabBarController.m
//  Oc-Dome
//
//  Created by 李含文 on 2018/11/12.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

#import "MyTabBarController.h"
#import "HWTabBar.h"

@interface MyTabBarController ()<UITabBarControllerDelegate>

@end

@implementation MyTabBarController


+ (void)load {
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    // 设置默认颜色
    NSMutableDictionary *defaultdic = [[NSMutableDictionary alloc] init];
    defaultdic[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [tabBarItem setTitleTextAttributes:defaultdic forState:UIControlStateNormal];
    // 设置选中颜色
    NSMutableDictionary *selecteddic = [[NSMutableDictionary alloc] init];
    selecteddic[NSForegroundColorAttributeName] = [UIColor redColor];
    [tabBarItem setTitleTextAttributes:selecteddic forState:UIControlStateSelected];
    // 设置字体大小
    //    tabBarItem.hw_setFont(12);
    NSMutableDictionary *fontdic = [[NSMutableDictionary alloc] init];
    fontdic[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    [tabBarItem setTitleTextAttributes:fontdic forState:UIControlStateNormal];
    // 设置tab背景颜色
    UITabBar *tab = [UITabBar appearance];
    [tab setTranslucent:YES];
    [tab setBackgroundColor:[UIColor whiteColor]];
    tab.barStyle = UIBarStyleBlack; // 隐藏黑线
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabBarItem];
    self.delegate = self;
}

#pragma mark - 设置子控制器
- (void)setTabBarItem {
    [self setChildControllerWithTitle:@"首页" VCName:@"HomeViewController"];
    [self setChildControllerWithTitle:@"" VCName:@"UIViewController"];
    [self setChildControllerWithTitle:@"我的" VCName:@"MeViewController"];
    // 设置自定义的tabbar
    [self setCustomtabbar];
}

//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
//    NSLog(@"点击的item:%ld title:%@", item.tag, item.title);
//}
- (void)setChildControllerWithTitle:(NSString *)title VCName:(NSString *)VCName {
    UIViewController *vc = [[NSClassFromString(VCName) alloc] init];
    vc.tabBarItem.title = title;
    vc.title = title;
    vc.navigationController.title = title;
    vc.tabBarItem.image = [UIImage hw_imageNamed:[NSString stringWithFormat:@"%@未选中", title]];
    vc.tabBarItem.selectedImage = [UIImage hw_imageNamed:[NSString stringWithFormat:@"%@选中", title]];
    MyNavigationController *nav = [[MyNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
// MARK: - 中间按钮相关
- (void)setCustomtabbar{
    HWWeakSelf(weakSelf)
    HWTabBar *tabbar = [[HWTabBar alloc] initWithBlock:^{
        NSInteger index = weakSelf.childViewControllers.count/2;
        weakSelf.selectedIndex = index;
    }];
    [self setValue:tabbar forKeyPath:@"tabBar"];
}
// MARK: 设置点击中间区域无效
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)viewController;
        if ([nav.viewControllers.firstObject isMemberOfClass:[UIViewController class]]) {
            return NO;
        }
    }
    return YES;
}

@end
