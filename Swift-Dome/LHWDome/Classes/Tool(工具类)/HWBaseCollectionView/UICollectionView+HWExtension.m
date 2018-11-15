//
//  UICollectionView+HWExtension.m
//  Swift-UICollectionView
//
//  Created by 李含文 on 2018/9/1.
//  Copyright © 2018年 李含文. All rights reserved.
//

#import "UICollectionView+HWExtension.h"
#import <objc/runtime.h>

@implementation UIView (HWExtension)
+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2 {
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}
@end

@implementation UICollectionView (HWExtension)
static const NSInteger kViewIdKey = 1;
- (void)setActionBlock:(void (^)(BOOL))actionBlock {
    objc_setAssociatedObject(self, &kViewIdKey, actionBlock, OBJC_ASSOCIATION_COPY);
}
- (void (^)(BOOL))actionBlock {
    return (void (^)(BOOL))objc_getAssociatedObject(self, &kViewIdKey);
}

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
    if (self.actionBlock == nil) {return;}
    self.actionBlock([self totalDataCount] > 0 ? YES : NO);
}
- (NSInteger)totalDataCount {
    NSInteger totalCount = 0;
    for (NSInteger section = 0; section < self.numberOfSections; section++) {
        totalCount += [self numberOfItemsInSection:section];
    }
    return totalCount;
}
@end
