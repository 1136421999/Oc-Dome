//
//  HWNestedViewController.m
//  OC_Nested(嵌套手势冲突)
//
//  Created by 李含文 on 2019/3/1.
//  Copyright © 2019年 SK丿希望. All rights reserved.
//

#import "HWNestedViewController.h"
#import "HWNestedTableView.h"
#import "HWNestedSubViewController.h"


#define TopView_Height 240
#define Screen_Size [UIScreen mainScreen].bounds.size
#define NAVBGColor [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:1]
@interface HWNestedViewController ()<UITableViewDelegate,UITableViewDataSource>

/** <#注释#> */
@property(nonatomic, strong) HWNestedTableView *tableView;
/** <#注释#> */
@property(nonatomic, strong) UIView *topView;
/** 当前的透明度 */
@property (nonatomic, assign) CGFloat currentAlpha;
/** <#注释#> */
@property(nonatomic, strong) HWNestedSubViewController *subView;
/** 是否可以滚动 */
@property (nonatomic, assign) BOOL isCanScroll;
@end

@implementation HWNestedViewController

- (HWNestedSubViewController *)subView {
    if (!_subView) {
        _subView = [HWNestedSubViewController new];
    }
    return _subView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setScroll) name:@"ScrollKey" object:nil];
    [self initData];
    [self setUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
}
- (void)initData {
    self.currentAlpha = 0;
    self.isCanScroll = YES;
}
/// 收到通知
- (void)setScroll {
    self.isCanScroll = YES;
}
- (void)subTabViewCanScroll:(BOOL)tag {
    self.subView.isCanScroll = tag;
    if (!tag) {
        self.tableView.contentOffset = CGPointZero;
    }
}
- (void)setUI {
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.topView];
}
- (void)setNav {
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[NAVBGColor colorWithAlphaComponent:self.currentAlpha]] forBarMetrics:UIBarMetricsDefault];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat naviH = [UIApplication sharedApplication].statusBarFrame.size.height+44;
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"父控制器%f", offsetY);
    // 监听父子视图滚动
    if (offsetY > -naviH) { // 到顶部 设置不可滑动 让子列表可以滑动
        scrollView.contentOffset = CGPointMake(0, -naviH);
        if (self.isCanScroll) {
            self.isCanScroll = NO;
            [self subTabViewCanScroll:YES];
        }
    } else {
        if (!self.isCanScroll) { // 不可以滑动 置顶
            scrollView.contentOffset = CGPointMake(0, -naviH);
        } else {
            scrollView.contentOffset = CGPointMake(0, offsetY);
        }
    }
    // 头视图设置
    [self setTopViewFrameWithOffsetY:offsetY];
    // 导航栏设置
    self.currentAlpha = (offsetY+TopView_Height)/(TopView_Height-naviH);
    [self setNav];
}
// MARK: - 设置头部视图Frame
- (void)setTopViewFrameWithOffsetY:(CGFloat)offsetY {
    CGRect frame = self.topView.frame;
    if (!self.isCanScroll) {
        frame.origin.y = -TopView_Height;
    } else {
    if (offsetY > -TopView_Height) {
        frame.origin.y = -(TopView_Height+offsetY);
    } else {
        frame.origin.y = 0;
        frame.size.height = -offsetY;
    }
    }
    self.topView.frame = frame;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellID"];
    [cell.contentView addSubview:self.subView.view];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Screen_Size.height;
}
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Size.width, TopView_Height)];
        _topView.backgroundColor = [UIColor yellowColor];
    }
    return _topView;
}
- (HWNestedTableView *)tableView {
    if (!_tableView) {
        _tableView = [[HWNestedTableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Size.width, Screen_Size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.contentInset = UIEdgeInsetsMake(TopView_Height, 0, 0, 0);
        _tableView.contentOffset = CGPointMake(0, -TopView_Height);
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCellID"];
    }
    return _tableView;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return theImage;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
