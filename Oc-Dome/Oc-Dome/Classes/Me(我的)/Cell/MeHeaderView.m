//
//  MeHeaderView.m
//  Oc-Dome
//
//  Created by 李含文 on 2019/4/13.
//  Copyright © 2019年 东莞市三心网络科技有限公司. All rights reserved.
//

#import "MeHeaderView.h"

@interface MeHeaderView()

@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation MeHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = hw_GradientColor;
    HWWeakSelf(weakSelf)
    [self.imageView hw_addTapGesture:^{
        if (weakSelf.iconClickBlock) {
            weakSelf.iconClickBlock(weakSelf.imageView);
        }
    }];
}

- (void)setContent:(NSString *)content {
    _content = content;
    self.label.text = content;
}

@end
