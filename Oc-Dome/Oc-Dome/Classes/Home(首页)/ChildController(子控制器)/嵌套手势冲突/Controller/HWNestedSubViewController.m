//
//  HWNestedSubViewController.m
//  OC_Nested(嵌套手势冲突)
//
//  Created by 李含文 on 2019/3/1.
//  Copyright © 2019年 SK丿希望. All rights reserved.
//

#import "HWNestedSubViewController.h"

@interface HWNestedSubViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation HWNestedSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"id"];
    [self.view addSubview:self.tableView];
}
//- (void)setIsCanScroll:(BOOL)isCanScroll {
//    _isCanScroll = isCanScroll;
//    self.tableView.scrollEnabled = isCanScroll;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    cell.textLabel.text = [NSString stringWithFormat:@"我是第%ld行", indexPath.item];
    return cell;
}

- (UITableView *)tableView{
    if (!_tableView) {
        CGFloat naviH = [UIApplication sharedApplication].statusBarFrame.size.height+44;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-naviH) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.bounces = YES;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (!self.isCanScroll) { // 不可以滑动
        scrollView.contentOffset = CGPointZero;
    } else { // 可以滑动
        if (scrollView.contentOffset.y < 0) { // 到顶了 通知
            scrollView.contentOffset = CGPointZero;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ScrollKey" object:nil];
            self.isCanScroll = NO;
        } else {
            scrollView.contentOffset = CGPointMake(0, offsetY);
        }
    }
}

@end
