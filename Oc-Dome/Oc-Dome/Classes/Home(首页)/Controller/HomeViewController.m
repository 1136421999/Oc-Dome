//
//  HomeViewController.m
//  Oc-Dome
//
//  Created by 李含文 on 2018/11/29.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

#import "HomeViewController.h"
#import "textCell.h"
@interface HomeViewController () <UITableViewDataSource>
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
    [self.itemArray addObjectsFromArray:@[@"雷达扫描",@""]];
    [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    textCell *cell = [tableView hw_dequeueReusableCell:[textCell class] and:indexPath];
    cell.titleLabel.text = _itemArray[indexPath.row];
    return  cell;
}
- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}
@end
