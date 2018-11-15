//
//  UIImage+HWExtension.m
//  Oc-Dome
//
//  Created by 李含文 on 2018/11/12.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

#import "UIImage+HWExtension.h"

@implementation UIImage (HWExtension)

/**
 取消图片渲染

 @param name 图片名称
 @return 不被渲染的图片
 */
+ (UIImage *)hw_imageNamed:(NSString *)name {
    UIImage *image = [UIImage imageNamed:name];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
@end
