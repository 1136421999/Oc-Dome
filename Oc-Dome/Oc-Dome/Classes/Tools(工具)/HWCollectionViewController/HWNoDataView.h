//
//  HWNoDataView.h
//  kzyjsq
//
//  Created by 李含文 on 2018/12/25.
//  Copyright © 2018年 李含文. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HWNoDataView : UIView
+ (HWNoDataView *)noDataView;
/** 显示文字 */
@property(nonatomic, strong) NSString *content;
/** 图片 */
@property(nonatomic, strong) UIImage *image;


@end

NS_ASSUME_NONNULL_END
