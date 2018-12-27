//
//  UICollectionView+HWExtension.m
//  Oc-Dome
//
//  Created by 李含文 on 2018/11/29.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

#import "UICollectionView+HWCategory.h"
#import "UIView+HWCategory.h"
#import <objc/runtime.h>

@implementation UICollectionViewCell (HWCategory)
+ (NSString *)hw_identifier {
    return [NSString stringWithFormat:@"%@ID",NSStringFromClass([self class])];
}
@end
static const NSInteger kViewIdKey = 1;
@implementation UICollectionView (HWCategory)

- (void)setHw_ishasDataBlock:(void (^)(BOOL))hw_ishasDataBlock {
    objc_setAssociatedObject(self, &kViewIdKey, hw_ishasDataBlock, OBJC_ASSOCIATION_COPY);
}
- (void (^)(BOOL))hw_ishasDataBlock {
    return (void (^)(BOOL))objc_getAssociatedObject(self, &kViewIdKey);
}

// MARK:  注册cell
- (void)hw_registerCell:(id)cell {
    NSString *cellName = [self getCellName:cell];
    NSString *reuseIdentifier = [NSString stringWithFormat:@"%@ID", cellName];
    if ([self hw_getNibPath:cellName]) {
        [self registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    } else {
        [self registerClass:NSClassFromString(cellName) forCellWithReuseIdentifier:reuseIdentifier];
    }
}
// MARK:  获取cell
- (id)hw_dequeueReusableCell:(id)cell and:(NSIndexPath *)indexPath {
    NSString *cellName = [self getCellName:cell];
    NSString *reuseIdentifier = (NSString *)[NSString stringWithFormat:@"%@ID", cellName];
    return [self dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
}
- (NSString *)getCellName:(id)cell {
    NSString *cellName;
    if ([cell isKindOfClass:[NSString class]]) {
        cellName = cell;
    } else {
        cellName = NSStringFromClass(cell);
    }
    return  cellName;
}
- (BOOL)hw_getNibPath:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"nib"];
    if (path == nil) { // 路径不存在
        return NO;
    } else { // 路径存在
        return YES;
    }
}
- (void)hw_registerCollectionHeaderView:(id)view {
    NSString *viewName = [self getCellName:view];
    NSString *reuseIdentifier = (NSString *)[NSString stringWithFormat:@"%@ID", viewName];
    if ([self hw_getNibPath:viewName]) { // nib
        [self registerNib:[UINib nibWithNibName:viewName bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifier];
    } else { // class
        [self registerClass:NSClassFromString(viewName) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifier];
    }
}
- (id)hw_dequeueCollectionHeaderView:(id)view and:(NSIndexPath *)indexPath {
    NSString *viewName = [self getCellName:view];
    NSString *reuseIdentifier = (NSString *)[NSString stringWithFormat:@"%@ID", viewName];
    // 如果这里报错看看有没有注册 或者 xib是否关联View
    return [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
}
- (void)hw_registerCollectionFooterView:(id)view {
    NSString *viewName = [self getCellName:view];
    NSString *reuseIdentifier = (NSString *)[NSString stringWithFormat:@"%@ID", viewName];
    if ([self hw_getNibPath:viewName]) { // nib
        [self registerNib:[UINib nibWithNibName:viewName bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseIdentifier];
    } else { // class
        [self registerClass:NSClassFromString(viewName) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifier];
    }
}
- (id)hw_dequeueCollectionFooterView:(id)view and:(NSIndexPath *)indexPath {
    NSString *viewName = [self getCellName:view];
    NSString *reuseIdentifier = (NSString *)[NSString stringWithFormat:@"%@ID", viewName];
    return [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
}

// MARK: - 判断是否有数据相关
+ (void)load{
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(hw_reloadData)];
    ///section
    [self exchangeInstanceMethod1:@selector(insertSections:) method2:@selector(hw_insertSections:)];
    [self exchangeInstanceMethod1:@selector(deleteSections:) method2:@selector(hw_deleteSections:)];
    [self exchangeInstanceMethod1:@selector(reloadSections:) method2:@selector(hw_reloadSections:)];
    ///item
    [self exchangeInstanceMethod1:@selector(insertItemsAtIndexPaths:) method2:@selector(hw_insertItemsAtIndexPaths:)];
    [self exchangeInstanceMethod1:@selector(deleteItemsAtIndexPaths:) method2:@selector(hw_deleteItemsAtIndexPaths:)];
    [self exchangeInstanceMethod1:@selector(reloadItemsAtIndexPaths:) method2:@selector(hw_reloadItemsAtIndexPaths:)];
}
- (void)hw_reloadData{
    [self hw_reloadData];
    [self hw_check];
}
///section
- (void)hw_insertSections:(NSIndexSet *)sections{
    [self hw_insertSections:sections];
    [self hw_check];
}
- (void)hw_deleteSections:(NSIndexSet *)sections{
    [self hw_deleteSections:sections];
    [self hw_check];
}
- (void)hw_reloadSections:(NSIndexSet *)sections{
    [self hw_reloadSections:sections];
    [self hw_check];
}

///item
- (void)hw_insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    [self hw_insertItemsAtIndexPaths:indexPaths];
    [self hw_check];
}
- (void)hw_deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    [self hw_deleteItemsAtIndexPaths:indexPaths];
    [self hw_check];
}
- (void)hw_reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    [self hw_reloadItemsAtIndexPaths:indexPaths];
    [self hw_check];
}
- (void)hw_check {
    if (self.hw_ishasDataBlock == nil) {return;}
    self.hw_ishasDataBlock([self totalDataCount] > 0 ? YES : NO);
}
- (NSInteger)totalDataCount {
    NSInteger totalCount = 0;
    for (NSInteger section = 0; section < self.numberOfSections; section++) {
        totalCount += [self numberOfItemsInSection:section];
    }
    return totalCount;
}
@end
