//
//  UIScrollView+HWCategory.m
//  Oc-Dome
//
//  Created by 李含文 on 2018/11/29.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

#import "UIScrollView+HWCategory.h"
#import <MJRefresh/MJRefresh.h>
#import <objc/runtime.h>
static NSString  * const hearderRefreshBlockKey = @"hearderRefreshBlockKey";
static NSString  * const FooterRefreshBlockKey = @"hearderRefreshBlockKey";
@implementation UIScrollView (HWCategory)

- (void)setHw_hearderRefreshBlock:(void (^)(void))hw_heardreRefreshBlock {
    if (self.mj_header == nil) {
        [self hw_addHearderRefresh];
    }
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(hearderRefreshBlockKey), hw_heardreRefreshBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(void))hw_hearderRefreshBlock {
    return objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(hearderRefreshBlockKey));
}

- (void)setHw_footerRefreshBlock:(void (^)(void))hw_footerRefreshBlock {
    if (self.mj_footer == nil) {
        [self hw_addFooterRefresh];
    }
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(FooterRefreshBlockKey), hw_footerRefreshBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(void))hw_footerRefreshBlock {
    return objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(FooterRefreshBlockKey));
}


- (void)hw_addHearderRefresh {
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf footerEndRefreshing];
        if ([weakSelf.mj_header isRefreshing]) {
            if (weakSelf.hw_hearderRefreshBlock != nil) {
                weakSelf.hw_hearderRefreshBlock();
            }
        }
    }];
    self.mj_header = header;
}
- (void)hw_addFooterRefresh {
    __weak typeof(self) weakSelf = self;
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf headerEndRefreshing];
        if ([weakSelf.mj_footer isRefreshing]) {
            if (weakSelf.hw_footerRefreshBlock != nil) {
                weakSelf.hw_footerRefreshBlock();
            }
        }
    }];
    [self.mj_footer endRefreshing];
    self.mj_footer = footer;
}
- (void)endRefreshing {
    [self headerEndRefreshing];
    [self footerEndRefreshing];
}
- (void)headerEndRefreshing {
    if ([self.mj_header isRefreshing]) {
        [self.mj_header endRefreshing];
    }
}
- (void)footerEndRefreshing {
    if ([self.mj_footer isRefreshing]) {
        [self.mj_footer endRefreshing];
    }
}
- (void)beginRefreshing {
    [self.mj_header beginRefreshing];
}
@end
