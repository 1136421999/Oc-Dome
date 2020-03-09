//
//  HWNoDataView.m
//  kzyjsq
//
//  Created by 李含文 on 2018/12/25.
//  Copyright © 2018年 李含文. All rights reserved.
//

#import "HWNoDataView.h"

@interface HWNoDataView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
/** <#注释#> */
@property(nonatomic, copy) void(^btnClickBlock)(void);
@end

@implementation HWNoDataView

+ (HWNoDataView *)noDataView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.button.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
}
- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}
- (void)setContent:(NSString *)content {
    _content = content;
    self.contentLabel.text = content;
}
- (void)setBtnTitle:(NSString *)title action:(void(^)(void))action {
    self.button.hidden = NO;
    [self.button setTitle:title forState:(UIControlStateNormal)];
    self.btnClickBlock = action;
}
- (IBAction)btnClick:(id)sender {
    if (self.btnClickBlock) {
        self.btnClickBlock();
    }
}
@end
