//
//  HWNestedSubViewController.h
//  OC_Nested(嵌套手势冲突)
//
//  Created by 李含文 on 2019/3/1.
//  Copyright © 2019年 SK丿希望. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HWNestedSubViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;
/** 是否可以滚动 */
@property (nonatomic, assign) BOOL isCanScroll; 


@end

NS_ASSUME_NONNULL_END
