//
//  MeViewController.m
//  Oc-Dome
//
//  Created by 李含文 on 2019/4/13.
//  Copyright © 2019年 东莞市三心网络科技有限公司. All rights reserved.
//

#import "MeViewController.h"
#import "MeCollectionViewCell.h"
#import "MeHeaderView.h"

@interface MeViewController ()

/** <#注释#> */
@property(nonatomic, strong) HWPictureManager *pictureManager;

/** <#注释#> */
@property(nonatomic, strong) MeHeaderView *topView;
@end

@implementation MeViewController
- (HWPictureManager *)pictureManager {
    if (!_pictureManager) {
        _pictureManager = [HWPictureManager new];
    }
    return _pictureManager;
}
- (MeHeaderView *)topView {
    if (!_topView) {
        _topView = [[NSBundle mainBundle] loadNibNamed:@"MeHeaderView" owner:nil options:nil].firstObject;
    }
    return _topView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.itemArray addObjectsFromArray:@[@[@"我的订单", @"地址管理", @"浏览记录"],@[@"设置", @"意见反馈", @"联系客服"]]];
    [self setCollectionView];
    [self setReusableView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self switchGradientColor];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.itemArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *array = self.itemArray[section];
    return array.count;
}
- (void)setCollectionView {
    HWWeakSelf(weakSelf)
    [self.collectionView hw_registerCell:[MeCollectionViewCell class]];
    [self setCellForRowBlock:^UICollectionViewCell * _Nonnull(NSIndexPath * _Nonnull indexPath) {
        return [weakSelf getMeCollectionViewCell:indexPath];
    } cellSizeBlock:^CGSize(NSIndexPath * _Nonnull indexPath) {
        return CGSizeMake(HWScreenW, 50);
    }];
}
- (UICollectionViewCell *)getMeCollectionViewCell:(NSIndexPath *)indexPath {
    MeCollectionViewCell *cell = [self.collectionView hw_dequeueReusableCell:[MeCollectionViewCell class] and:indexPath];
    NSArray *array = self.itemArray[indexPath.section];
    NSString *title = array[indexPath.item];
    cell.titleLabel.text = title;
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 10, 0);
}

- (void)setReusableView {
    HWWeakSelf(weakSelf)
    [self.collectionView hw_registerCollectionHeaderView:[MeHeaderView class]];
    [self setReusableViewBlock:^UICollectionReusableView * _Nonnull(NSString * _Nonnull kind, NSIndexPath * _Nonnull indexPath) {
        if (kind == UICollectionElementKindSectionHeader && indexPath.section == 0) {
            MeHeaderView *view = [weakSelf.collectionView hw_dequeueCollectionHeaderView:[MeHeaderView class] and:indexPath];
            view.content = @"测试";
            view.iconClickBlock = ^(UIImageView * _Nonnull imageView) {
                [weakSelf.pictureManager hw_showTakingAndPhotoAlbum:^(UIImage * _Nonnull image) {
                    imageView.image = image;
                }];
            };
            return view;
        }
        return [UICollectionReusableView new];
    } headerSizeBlock:^CGSize(NSInteger section) {
        if (section == 0) {
            return CGSizeMake(HWScreenW, 100);
        } else {
            return CGSizeZero;
        }
    } footerSizeBlock:^CGSize(NSInteger section) {
        return CGSizeZero;
    }];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = self.itemArray[indexPath.section];
    NSString *title = array[indexPath.item];
    if ([title isEqualToString:@"意见反馈"]) {
        [self pushControllerWithName:@"FeedbackViewController"];
    } else if ([title isEqualToString:@""]) {
        
    }
}
@end
