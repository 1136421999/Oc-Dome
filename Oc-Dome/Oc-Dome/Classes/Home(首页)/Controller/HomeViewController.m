//
//  HomeViewController.m
//  Oc-Dome
//
//  Created by 李含文 on 2018/11/29.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

#import "HomeViewController.h"
#import "textCell.h"
@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>
/** <#注释#> */
@property(nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property(nonatomic, strong) NSMutableArray *itemArray;
@end

@implementation HomeViewController
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        __weak typeof(self) weakSelf = self;
        _tableView.hw_hearderRefreshBlock = ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf loadData];
            });
        };
        _tableView.hw_footerRefreshBlock = ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf loadData];
            });
        };
        _tableView.tableFooterView = [UIView new];
        [_tableView beginRefreshing];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}
- (void)loadData {
    [self.tableView endRefreshing];
    [self.itemArray removeAllObjects];
    [self.itemArray addObjectsFromArray:@[@"雷达扫描",@"富文本扩展",@"多图浏览器",@"FMDB封装",@"嵌套手势冲突",@"UILabel添加点击事件",@"View添加阴影",@"语音播报",@"Sorket服务器端",@"Sorket客服端"]];
    [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    textCell *cell = [tableView hw_dequeueReusableCell:[textCell class] and:indexPath];
    cell.titleLabel.hw_setText(_itemArray[indexPath.row]);
    return  cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.itemArray[indexPath.row];
    if ([title isEqualToString:@"雷达扫描"]) {
        
    } else if ([title isEqualToString:@"富文本扩展"]) {
        [self pushControllerWithName:@"NSMutableAttributedStringViewController"];
    } else if ([title isEqualToString:@"多图浏览器"]) {
         [self pushControllerWithName:@"YCCollectionViewController"];
    } else if ([title isEqualToString:@"FMDB封装"]) {
         [self pushControllerWithName:@"FMDBViewController"];
    } else if ([title isEqualToString:@"嵌套手势冲突"]) {
        [self pushControllerWithName:@"HWNestedViewController"];
    } else if ([title isEqualToString:@"UILabel添加点击事件"]) {
        [self pushControllerWithName:@"UILabelClickViewController"];
    } else if ([title isEqualToString:@"View添加阴影"]) {
        [self pushControllerWithName:@"YCShadowViewController"];
    } else if ([title isEqualToString:@"语音播报"]) {
        [self pushControllerWithName:@"SpeechViewController"];
    } else if ([title isEqualToString:@"Sorket服务器端"]) {
        [self pushControllerWithName:@"GCDSocketServerViewController"];
    } else if ([title isEqualToString:@"Sorket客服端"]) {
        [self pushControllerWithName:@"GCDSocketClientViewController"];
    }
}
- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}
@end
