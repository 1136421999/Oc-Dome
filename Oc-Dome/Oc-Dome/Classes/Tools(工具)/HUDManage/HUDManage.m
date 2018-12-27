//
//  HUDManage.m
//  kzyjsq
//
//  Created by 李含文 on 2018/12/3.
//  Copyright © 2018年 李含文. All rights reserved.
//

#import "HUDManage.h"
#import <UIKit/UIKit.h>
@implementation HUDManage

+ (void)showHUDWithTitle:(NSString *)title {
    [HWProgressHUD showType:(HWProgressHUDTypeText) text:title time:1];
}
+ (void)showLoadingHUD {
    [self showLoadingHUDWithTitle:@"加载中..."];
}
+ (void)showLoadingHUDWithTitle:(NSString *)title {
    [HWProgressHUD showType:(HWProgressHUDTypeLoading) text:title time:60];
}
+ (void)dismiss {
    [HWProgressHUD dismiss];
}
@end

/// 最大宽度
#define maxwidth ([UIScreen mainScreen].bounds.size.width - 100)
/// 背景颜色
#define bgColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]
/// 文字大小
#define label_font [UIFont systemFontOfSize:14]
#define activityIndicatorViewFrame CGRectMake(0,15,50,50)
static UIWindow *currentWindow;
@interface HWProgressHUD ()

@end

@implementation HWProgressHUD

+ (void)showType:(HWProgressHUDType)type text:(NSString *)text time:(NSInteger)time {
    [self dismiss];
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor clearColor];
    currentWindow = window;
    UIView *mainView = [[UIView alloc] init];
    mainView.layer.cornerRadius = 10;
    mainView.backgroundColor = bgColor;
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.numberOfLines = 0;
    label.font = label_font;
    label.textAlignment = NSTextAlignmentCenter;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    if (label.frame.size.width > maxwidth) {
        CGRect frame = label.frame;
        frame.size.width = maxwidth;
        label.frame = frame;
    }
    CGRect frame;
    CGFloat height = text.length > 0 ? [text boundingRectWithSize:CGSizeMake(maxwidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:label.font, NSFontAttributeName, nil] context:nil].size.height : 0;
    if (type == HWProgressHUDTypeLoading) {
        if (text.length > 0) {
            frame = CGRectMake(0, 0, label.bounds.size.width + activityIndicatorViewFrame.size.width, height + 2*activityIndicatorViewFrame.size.height);
        } else {
            CGFloat wh = activityIndicatorViewFrame.size.width+2*activityIndicatorViewFrame.origin.y;
            frame = CGRectMake(0, 0, wh, wh);
        }
        mainView.frame = frame;
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:activityIndicatorViewFrame];
        [activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicatorView setBackgroundColor:[UIColor clearColor]];
        [mainView addSubview:activityIndicatorView];
        [activityIndicatorView startAnimating];
        activityIndicatorView.center = CGPointMake(mainView.center.x, activityIndicatorView.center.y);
        label.center = CGPointMake(mainView.center.x, CGRectGetMaxY(activityIndicatorView.frame)+activityIndicatorViewFrame.size.height/2);
        CGRect frame = label.frame;
        frame.size.height = height;
        label.frame = frame;
    } else {
        frame = CGRectMake(0, 0, label.bounds.size.width + 50, height + 30);
        mainView.frame = frame;
        label.center = mainView.center;
        CGRect frame = label.frame;
        frame.size.height = height;
        label.frame = frame;
    }
    
    [mainView addSubview:label];
    mainView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    [window addSubview:mainView];
    [window makeKeyAndVisible];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf dismiss];
    });
}
+ (void)dismiss {
    if (currentWindow) {
        [currentWindow resignKeyWindow];
        currentWindow = nil;
    }
}
@end


