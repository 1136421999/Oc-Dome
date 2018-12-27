//
//  HWPictureManager.m
//  kzyjsq
//
//  Created by 李含文 on 2018/12/4.
//  Copyright © 2018年 李含文. All rights reserved.
//

#import "HWPictureManager.h"
#import <AVKit/AVKit.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>



@interface HWPictureManager () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property(nonatomic, copy) void(^selectedImageBlock)(UIImage *image);

@end

@implementation HWPictureManager

- (void)hw_showTakingAndPhotoAlbum:(void(^)(UIImage *image))action {
    [HWAlertManager hw_showSheet:nil message:nil actionTitles:@[@"拍照上传",@"本地上传"] actionBlock:^(NSInteger index) {
        if (index == 0) {
            [self hw_showTakingPictures:^(UIImage *image) {
                action(image);
            }];
        } else {
            [self hw_showPhotoAlbum:^(UIImage *image) {
                action(image);
            }];
        }
    }];
}

/// 快速单选相册
- (void)hw_showPhotoAlbum:(void(^)(UIImage *image))action {
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypePhotoLibrary)]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.navigationBar.barTintColor = [UIColor whiteColor];
        picker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
        picker.navigationBar.tintColor = [UIColor blackColor];
        self.selectedImageBlock = action;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:picker animated:YES completion:nil];
    } else {
        HWLog(@"读取相册失败");
    }
}
/// 快速拍照
- (void)hw_showTakingPictures:(void(^)(UIImage *image))action {
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.navigationBar.barTintColor = [UIColor whiteColor];
        picker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
        picker.navigationBar.tintColor = [UIColor blackColor];
        self.selectedImageBlock = action;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:picker animated:YES completion:nil];
    } else {
        HWLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *portraitImg = [info objectForKey:UIImagePickerControllerEditedImage];
    if (self.selectedImageBlock) {
        self.selectedImageBlock(portraitImg);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
