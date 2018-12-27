//
//  HWShowBigImageView.h
//  图片浏览器
//
//  Created by Hanwen on 2017/12/23.
//  Copyright © 2017年 SK丿希望. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWShowBigImageView : UIView<UIScrollViewDelegate>
/**
 开始查看图片
 @param imageView 要显示的imageView
 */
+ (void)showBigImage:(UIImageView *)imageView;
@end
