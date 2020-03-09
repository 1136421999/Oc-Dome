//
//  MeHeaderView.h
//  Oc-Dome
//
//  Created by 李含文 on 2019/4/13.
//  Copyright © 2019年 东莞市三心网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

/** <#注释#> */
@property(nonatomic, strong) NSString *content;
/** <#注释#> */
@property(nonatomic, copy) void(^iconClickBlock)(UIImageView *imageView);

@end

NS_ASSUME_NONNULL_END
