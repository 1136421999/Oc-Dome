//
//  HWPayPopoManage.m
//  kzyjsq
//
//  Created by 李含文 on 2018/12/17.
//  Copyright © 2018年 李含文. All rights reserved.
//

#import "HWPayPopoManage.h"

static HWPayPopoManageView *mainView;
@implementation HWPayPopoManage


+ (void)showTitle:(NSString *)title moeny:(NSString *)money action:(void(^)(NSString *password))action otherAction:(void(^)(void))otherAction {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    HWPayPopoManageView *view = [[HWPayPopoManageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    mainView = view;
    HWWeakSelf(weakSelf)
    view.touchesBeganBlock = ^{
        [weakSelf hidden];
    };
    
    HWPayPopoView * popoView = [self popoView];
    popoView.titleLabel.text = title;
    popoView.moneyLabel.text = money;
    [view addSubview:popoView];
    
    UILabel *label = [self promptLabel];
    label.y = popoView.top - 40;
    [view addSubview:label];
    popoView.buttonClickBlock = ^(HWPayViewClickType type, NSString * _Nonnull password) {
        if (type == HWPayViewClickTypeConfirm) {
            if (password.length != 6) {
                label.text = @"请输入密码";
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    label.text = @"";
                });
                return;
            } else {
                action(password);
            }
        } else if (type == HWPayViewClickTypeForget) {
            otherAction();
        }
        [weakSelf hidden];
    };
    [window addSubview:view];
}
+ (HWPayPopoView *)popoView {
    HWPayPopoView *popoView = [HWPayPopoView payPopoView];
    popoView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-320)/2, ([UIScreen mainScreen].bounds.size.height-290-260), 320, 290);
    return popoView;
}
+ (UILabel *)promptLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
+ (void)hidden {
    if (mainView) {
        [mainView removeFromSuperview];
        mainView = nil;
    }
}
@end

@interface HWPayPopoManageView()

@end

@implementation HWPayPopoManageView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.touchesBeganBlock) {
        self.touchesBeganBlock();
    }
}

@end
