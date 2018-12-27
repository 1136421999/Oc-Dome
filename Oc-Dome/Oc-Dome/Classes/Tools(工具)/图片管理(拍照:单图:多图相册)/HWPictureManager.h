//
//  HWPictureManager.h
//  kzyjsq
//
//  Created by 李含文 on 2018/12/4.
//  Copyright © 2018年 李含文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HWAlertManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface HWPictureManager : NSObject

/** 快速拍照与相册 */
- (void)hw_showTakingAndPhotoAlbum:(void(^)(UIImage *image))action;
/** 快速单选相册 */
- (void)hw_showPhotoAlbum:(void(^)(UIImage *image))action;
/** 快速拍照 */
- (void)hw_showTakingPictures:(void(^)(UIImage *image))action;
@end

NS_ASSUME_NONNULL_END
