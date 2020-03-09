//
//  HWTabBar.m
//  Oc-Dome
//
//  Created by 李含文 on 2019/1/28.
//  Copyright © 2019年 东莞市三心网络科技有限公司. All rights reserved.
//

#import "HWTabBar.h"

@interface HWTabBar()

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, copy) void(^actionBlock)(void);

@end

@implementation HWTabBar
//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        self.backgroundColor = hw_BGColor;
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setImage:[UIImage imageNamed:@"tabbar5"] forState:UIControlStateNormal];
//        button.bounds = CGRectMake(0, 0, 64, 64);
//        self.centerBtn = button;
//        [self addSubview:button];
//
//        self.backgroundImage = [UIImage imageNamed:@"TabBar_BG"]; // 设置背景图片
//        self.barStyle = UIBarStyleBlack; // 隐藏黑线
//    }
//    return self;
//}
// MARK: - 添加黑线
- (void)addLineView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, -1, [UIScreen mainScreen].bounds.size.width, 1)];
    topView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:topView];
}
- (id)initWithBlock:(void(^)(void))block {
    if (self = [super init]) {
        self.actionBlock = block;
        self.backgroundColor = hw_BGColor;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"tabbar5"] forState:UIControlStateNormal];
        button.bounds = CGRectMake(0, 0, 64, 64);
        self.centerBtn = button;
        [self addSubview:button];
        [button addTarget:self action:@selector(centerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.backgroundImage = [UIImage imageNamed:@"TabBar_BG"]; // 设置背景图片
        self.barStyle = UIBarStyleBlack; // 隐藏黑线
    }
    return self;
}
#pragma mark - 自定义中心按钮相应方法
- (void)centerBtnClick:(UIButton *)btn{
    self.actionBlock();
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.centerBtn.center = CGPointMake(self.width * 0.5, self.height * 0.2);
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.isHidden == NO) {
        CGPoint newPoint = [self convertPoint:point toView:self.centerBtn];
        if ( [self.centerBtn pointInside:newPoint withEvent:event]) {
            return self.centerBtn;
        }else{
            return [super hitTest:point withEvent:event];
        }
    } else {
        return [super hitTest:point withEvent:event];
    }
}


@end
