//
//  UICollectionView+HWExtension.h
//  Oc-Dome
//
//  Created by 李含文 on 2018/11/29.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionViewCell (HWCategory)

/**
 快速获取注册cellid
 @return 注册的类名+ID
 */
+ (NSString *)hw_identifier;
@end

NS_ASSUME_NONNULL_END
NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (HWCategory)

/** 是否有数据回调 */
@property(nonatomic, copy) void(^hw_ishasDataBlock)(BOOL tag);
/**
 快速注册cell 根据传入的cellName自动判断是注册的xib还是Class
 @param cell cell的class 或者cell字符串
 */
- (void)hw_registerCell:(id)cell;

/**
 快速获取cell
 @param cell cell的class 或者cell字符串
 @param indexPath 对应的NSIndexPath
 @return cell
 */
- (id)hw_dequeueReusableCell:(id)cell and:(NSIndexPath *)indexPath;

/**
 快速注册头部
 @param view view的class 或者view字符串
 */
- (void)hw_registerCollectionHeaderView:(id)view;

/**
 快速返回头部
 @param view view的class 或者view字符串
 @param indexPath indexPath 对应的NSIndexPath
 @return UICollectionReusableView
 */
- (id)hw_dequeueCollectionHeaderView:(id)view and:(NSIndexPath *)indexPath;
/**
 快速注册尾部
 @param view view的class 或者view字符串
 */
- (void)hw_registerCollectionFooterView:(id)view;
/**
 快速返回尾部
 @param view view的class 或者view字符串
 @param indexPath indexPath 对应的NSIndexPath
 @return UICollectionReusableView
 */
- (id)hw_dequeueCollectionFooterView:(id)view and:(NSIndexPath *)indexPath;


@end

NS_ASSUME_NONNULL_END
