//
//  HWAlertManager.m
//  kzyjsq
//
//  Created by 李含文 on 2018/12/4.
//  Copyright © 2018年 李含文. All rights reserved.
//

#import "HWAlertManager.h"

@implementation HWAlertManager


+ (void)hw_showSheet:(id _Nullable)title message:(id _Nullable)message actionTitles:(NSArray<NSString *> *)titles actionBlock:(void(^)(NSInteger index))actionBlock {
    if (titles.count == 0) {return;}
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleActionSheet)];
    for (int i = 0; i<titles.count; i++) {
        NSString *str = titles[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:str style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            actionBlock(i);
        }];
        [alert addAction:action];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

+ (void)hw_showAlert:(id _Nullable)title message:(id _Nullable)message actionTitles:(NSArray<NSString *> *)titles actionBlock:(void(^)(NSInteger index))actionBlock {
    if (titles.count == 0) {return;}
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    for (int i = 0; i<titles.count; i++) {
        NSString *str = titles[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:str style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            actionBlock(i);
        }];
        [alert addAction:action];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}
@end
