//
//  UIImage+HWExtension.h
//  Oc-Dome
//
//  Created by 李含文 on 2018/11/12.
//  Copyright © 2018年 东莞市三心网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HWCategory)
/**
 取消图片渲染
 @param name 图片名称
 @return 不被渲染的图片
 */
+ (UIImage *)hw_imageNamed:(NSString *)name;

/**
 颜色转图片 默认尺寸是屏幕大小
 @param color 颜色
 @return 图片
 */
+ (UIImage *)hw_imageWithColor:(UIColor *)color;
/**
 保留四边拉伸中间
 @param imageName 图片名称
 @return 拉伸的图片
 */
+ (UIImage *)hw_KeepTensileWithImageNamed:(NSString *)imageName;

// 加载Gif
+ (UIImage *)hw_GIFWithData:(NSData *)data;

+ (UIImage *)hw_GIFWithNamed:(NSString *)name;
@end
