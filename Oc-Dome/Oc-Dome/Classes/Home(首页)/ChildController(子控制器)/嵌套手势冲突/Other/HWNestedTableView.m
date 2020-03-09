//
//  HWNestedTableView.m
//  OC_Nested(嵌套手势冲突)
//
//  Created by 李含文 on 2019/3/1.
//  Copyright © 2019年 SK丿希望. All rights reserved.
//

#import "HWNestedTableView.h"

@implementation HWNestedTableView

/** 同时识别多个手势 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end
