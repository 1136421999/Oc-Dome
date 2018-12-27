//
//  UIScrollView+HWCategory.h
//  Oc-Dome
//
//  Created by 李含文 on 2018/11/29.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (HWCategory)
/** 直接回调下拉刷新 无需添加 */
@property(nonatomic, copy) void(^hw_hearderRefreshBlock)(void);
/** 直接回调上拉刷新 无需添加 */
@property(nonatomic, copy) void(^hw_footerRefreshBlock)(void);
/** 结束上下拉刷新 */
- (void)endRefreshing;
/** 开始下拉刷新 */
- (void)beginRefreshing;
@end

NS_ASSUME_NONNULL_END
