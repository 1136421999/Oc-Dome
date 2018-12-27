//
//  UIViewController+HWExtension.m
//  Oc-Dome
//
//  Created by 李含文 on 2018/11/13.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

#import "UIViewController+HWCategory.h"
#import <objc/runtime.h>

@implementation UIViewController (HWCategory)
- (void)setBGColor {
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)setBGColor:(UIColor *)color {
    self.view.backgroundColor = color;
}

- (void)setTitle:(NSString *)title {
    self.navigationItem.title = title;
}

- (void)pushControllerWithVC:(UIViewController *)vc {
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pushControllerWithName:(NSString *)VCName {
    UIViewController *vc = [[NSClassFromString(VCName) alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pushControllerWithName:(NSString *)VCName otherSettings:(void(^)(UIViewController *vc))otherSettings {
    UIViewController *vc = [[NSClassFromString(VCName) alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    if (otherSettings) {
        otherSettings(vc);
    }
}
- (void)pushControllerWithName:(NSString *)VCName otherSettings:(void(^)(UIViewController *vc))otherSettings animated:(BOOL)animated{
    UIViewController *vc = [[NSClassFromString(VCName) alloc] init];
    [self.navigationController pushViewController:vc animated:animated];
    if (otherSettings) {
        otherSettings(vc);
    }
}

- (void)presentControllerWithVC:(UIViewController *)vc isAddNavigation:(BOOL)isAddNavigation{
    if (isAddNavigation) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:^{}];
    } else {
        [self presentViewController:vc animated:YES completion:^{}];
    }
}
- (void)presentControllerWithName:(NSString *)VCName otherSettings:(void(^)(UIViewController *vc))otherSettings isAddNavigation:(BOOL)isAddNavigation{
    if (isAddNavigation) {
        UIViewController *vc = [[NSClassFromString(VCName) alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:^{}];
        if (otherSettings) {
            otherSettings(vc);
        }
    } else {
        UIViewController *vc = [[NSClassFromString(VCName) alloc] init];
        [self presentViewController:vc animated:YES completion:^{}];
        if (otherSettings) {
            otherSettings(vc);
        }
    }
}
- (void)presentControllerWithName:(NSString *)VCName otherSettings:(void(^)(UIViewController *vc))otherSettings isAddNavigation:(BOOL)isAddNavigation animated:(BOOL)animated {
    if (isAddNavigation) {
        UIViewController *vc = [[NSClassFromString(VCName) alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:animated completion:^{}];
        if (otherSettings) {
            otherSettings(vc);
        }
    } else {
        UIViewController *vc = [[NSClassFromString(VCName) alloc] init];
        [self presentViewController:vc animated:animated completion:^{}];
        if (otherSettings) {
            otherSettings(vc);
        }
    }
}

- (void)popToViewControllerWithName:(NSString *)name {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:NSClassFromString(name)]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}
- (void)popToRootViewController {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end


static NSString *const kOriginDelegate = @"kOriginDelegate";
@implementation UINavigationController (HWExtension)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originSelector = @selector(viewDidLoad);
        SEL swizzledSelector = @selector(new_viewDidLoad);
        
        Method originMethod = class_getInstanceMethod(class, originSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod = class_addMethod(class,
                                            originSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originMethod),
                                method_getTypeEncoding(originMethod));
        } else {
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
    });
}

- (void)new_viewDidLoad
{
    [self new_viewDidLoad];
    
    objc_setAssociatedObject(self, [kOriginDelegate UTF8String], self.interactivePopGestureRecognizer.delegate, OBJC_ASSOCIATION_ASSIGN);
    self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

#pragma mark - 按钮

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    
    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    
    BOOL shouldPop = YES;
    UIViewController* vc = [self topViewController];
    if([vc respondsToSelector:@selector(navigationShouldPopOnBackButton)]) {
        shouldPop = [vc navigationShouldPopOnBackButton];
    }
    
    if(shouldPop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    } else {
        for(UIView *subview in [navigationBar subviews]) {
            if(0. < subview.alpha && subview.alpha < 1.) {
                [UIView animateWithDuration:.25 animations:^{
                    subview.alpha = 1.;
                }];
            }
        }
    }
    return NO;
}

#pragma mark - 手势

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        UIViewController *vc = [self topViewController];
        if([vc respondsToSelector:@selector(navigationShouldPopOnBackButton)]) {
            return [vc navigationShouldPopOnBackButton];
        }
        id<UIGestureRecognizerDelegate> originDelegate = objc_getAssociatedObject(self, [kOriginDelegate UTF8String]);
        return [originDelegate gestureRecognizerShouldBegin:gestureRecognizer];
    }
    return YES;
}

@end
