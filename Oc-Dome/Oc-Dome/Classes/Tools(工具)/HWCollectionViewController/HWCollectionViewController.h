//
//  HWCollectionViewController.h
//  Oc-Dome
//
//  Created by 李含文 on 2018/12/1.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWNoDataView.h"

typedef enum : NSUInteger {
    HWRefreshTypeDefault = 0, // 默认上下拉
    HWRefreshTypeHearder, // 只有下拉
    HWRefreshTypeFooter, // 只有上拉
} HWRefreshType;


NS_ASSUME_NONNULL_BEGIN

@interface HWCollectionViewController : BaseViewController<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
/** 刷新角标 */
@property(nonatomic, assign) NSInteger page;
/** <#注释#> */
@property(nonatomic, strong) UICollectionView *collectionView;
/** 用于快捷存储模型 */
@property(nonatomic, strong) NSMutableArray *itemArray;
/** 用于修改布局 */
@property(nonatomic, strong) UICollectionViewLayout *flowLayout;

/** 缺失view */
@property(nonatomic, strong) HWNoDataView *noDataView;

// MARK: - 设置cell
/**
 快速设置cell
 @param cellForRowBlock 设置cell回调
 @param cellSizeBlock 设置cell的size回调
 */
- (void)setCellForRowBlock:(UICollectionViewCell *(^)(NSIndexPath *indexPath))cellForRowBlock
             cellSizeBlock:(CGSize(^)(NSIndexPath *indexPath))cellSizeBlock;
// MARK: - 设置头尾部
/**
 快速设置头尾部
 @param reusableViewBlock 设置头尾部回调
 @param headerSizeBlock 设置头部的size回调
 @param footerSizeBlock 设置尾部的size回调
 */
- (void)setReusableViewBlock:(UICollectionReusableView *(^)(NSString *kind,NSIndexPath *indexPath))reusableViewBlock
             headerSizeBlock:(CGSize(^)(NSInteger section))headerSizeBlock
             footerSizeBlock:(CGSize(^)(NSInteger section))footerSizeBlock;
// MARK: - 刷新相关
/**
 设置刷新
 @param type 刷新样式
 @param isAuto 是否每次进入都执行page=1的刷新
 */
- (void)setRefreshType:(HWRefreshType)type isAuto:(BOOL)isAuto;
/**
 设置刷新 子类重写 只要刷新才会来
 @param page 角标
 */
- (void)loadData:(NSInteger)page;
/** 结束刷新 */
- (void)endRefreshing;
/** 执行下拉刷新 */
- (void)beginRefreshing;
@end

NS_ASSUME_NONNULL_END
