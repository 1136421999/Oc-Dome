//
//  HWCollectionViewController.m
//  Oc-Dome
//
//  Created by 李含文 on 2018/12/1.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

#import "HWCollectionViewController.h"


@interface HWCollectionViewController ()

@property(nonatomic, copy) UICollectionViewCell *(^cellForRow)(NSIndexPath *indexPath);
@property(nonatomic, copy)  CGSize(^cellSize)(NSIndexPath *indexPath);
@property(nonatomic, copy) UICollectionReusableView *(^reusableView)(NSString *kind,NSIndexPath *indexPath);
@property(nonatomic, copy) CGSize(^headerSize)(NSInteger section);
@property(nonatomic, copy) CGSize (^footerSize)(NSInteger section);

@property(nonatomic, assign) BOOL isAutoRefresh;

@end

@implementation HWCollectionViewController
- (void)setPage:(NSInteger)page {
    _page = page;
}
- (void)setFlowLayout:(UICollectionViewLayout *)flowLayout {
    _flowLayout = flowLayout;
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView setCollectionViewLayout:flowLayout];
}
- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewLayout *fl;
        if(self.flowLayout) {
            fl = self.flowLayout;
        } else {
            UICollectionViewFlowLayout *myfl = [[UICollectionViewFlowLayout alloc] init];
            myfl.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);
            myfl.minimumLineSpacing = 0;
            myfl.minimumInteritemSpacing = 0;
            myfl.scrollDirection = UICollectionViewScrollDirectionVertical;
            fl = myfl;
        }
        CGRect frame = CGRectMake(0, self.view.y, HWScreenW, HWScreenH - hw_navHeight);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:fl];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        __weak typeof(self) weakSelf = self;
        _collectionView.hw_ishasDataBlock = ^(BOOL tag) {
            weakSelf.noDataView.hidden = tag;
        };
    }
    return _collectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)addNoDataView {
    self.noDataView = [HWNoDataView noDataView];
    [self.collectionView addSubview:self.noDataView];
    [self.collectionView sendSubviewToBack:self.noDataView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.collectionView.mj_header.isRefreshing && self.isAutoRefresh == true) {
        self.page = 1;
        [self loadData:self.page];
    }
}

- (void)loadData:(NSInteger)page {}

- (void)setRefreshType:(HWRefreshType)type isAuto:(BOOL)isAuto {
    if (![self.view.subviews containsObject:self.collectionView]) {return;}
    [self addNoDataView];
    self.isAutoRefresh = isAuto;
    __weak typeof(self) weakSelf = self;
    switch (type) {
        case HWRefreshTypeDefault: {
            self.collectionView.hw_hearderRefreshBlock = ^{
                weakSelf.page = 1;
                [weakSelf loadData:weakSelf.page];
            };
            self.collectionView.hw_footerRefreshBlock = ^{
                weakSelf.page += 1;
                [weakSelf loadData:weakSelf.page];
            };
            [self.collectionView beginRefreshing];
            break;}
        case HWRefreshTypeHearder: {
            self.collectionView.hw_hearderRefreshBlock = ^{
                weakSelf.page = 1;
                [weakSelf loadData:weakSelf.page];
            };
            [self.collectionView beginRefreshing];
            break;}
        case HWRefreshTypeFooter: {
            self.page = 1;
            [weakSelf loadData:weakSelf.page];
            self.collectionView.hw_footerRefreshBlock = ^{
                weakSelf.page += 1;
                [weakSelf loadData:weakSelf.page];
            };
            break;}
        default:
            break;
    }
    if (self.collectionView.mj_footer) {
        [self.collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        if (!self.collectionView.mj_footer) {return;}
        CGFloat offset = self.collectionView.contentSize.height;
        if (offset < self.collectionView.height - hw_navHeight) {
            self.collectionView.mj_footer.hidden = YES;
        } else {
            self.collectionView.mj_footer.hidden = NO;
        }
    }
}
- (void)endRefreshing {
    if (![self.view.subviews containsObject:self.collectionView]) {return;}
    if (!self.collectionView.mj_header && !self.collectionView.mj_footer) {return;};
    [self.collectionView endRefreshing];
}
- (void)beginRefreshing {
    if (![self.view.subviews containsObject:self.collectionView]) {return;}
    if (!self.collectionView.mj_header) {return;};
    [self.collectionView beginRefreshing];
}
- (void)setCellForRowBlock:(UICollectionViewCell *(^)(NSIndexPath *indexPath))cellForRowBlock
             cellSizeBlock:(CGSize(^)(NSIndexPath *indexPath))cellSizeBlock {
    [self.view addSubview:self.collectionView];
    self.cellForRow = cellForRowBlock;
    self.cellSize = cellSizeBlock;
}
- (void)setReusableViewBlock:(UICollectionReusableView *(^)(NSString *kind,NSIndexPath *indexPath))reusableViewBlock
             headerSizeBlock:(CGSize(^)(NSInteger section))headerSizeBlock
             footerSizeBlock:(CGSize(^)(NSInteger section))footerSizeBlock {
    if (![self.view.subviews containsObject:self.collectionView]) {return;}
    self.reusableView = reusableViewBlock;
    self.headerSize = headerSizeBlock;
    self.footerSize = footerSizeBlock;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellForRow(indexPath);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellSize(indexPath);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return self.reusableView(kind,indexPath);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (self.headerSize == nil){
        return CGSizeZero;
    }
    return self.headerSize(section);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (self.footerSize == nil){
        return CGSizeZero;
    }
    return self.footerSize(section);
}
- (void)dealloc {
    if (_collectionView.mj_footer) {
        [_collectionView removeObserver:self forKeyPath:@"contentSize"];
    }
}

@end

