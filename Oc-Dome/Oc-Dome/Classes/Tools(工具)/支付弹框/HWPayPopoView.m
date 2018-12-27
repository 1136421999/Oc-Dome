//
//  HWPayPopoView.m
//  kzyjsq
//
//  Created by 李含文 on 2018/12/17.
//  Copyright © 2018年 李含文. All rights reserved.
//

#import "HWPayPopoView.h"
#import "WCLPassWordView.h"
@interface HWPayPopoView()<WCLPassWordViewDelegate>
@property (weak, nonatomic) IBOutlet WCLPassWordView *editorView;

@end

@implementation HWPayPopoView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.editorView.delegate = self;
    self.editorView.pointColor = [UIColor blackColor];
    self.editorView.rectColor = [@"E6E6E6" hw_hexColor];
}

+ (HWPayPopoView *)payPopoView {
    HWPayPopoView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HWPayPopoView class]) owner:nil options:nil] lastObject];
    if (view) {
        return view;
    } else {
        return [[HWPayPopoView alloc] init];
    }
}
- (void)passWordCompleteInput:(WCLPassWordView *)passWord {
    HWLog(@"%@",passWord.textStore);
    [self.editorView endEditing:YES];
}
- (IBAction)buttonClick:(UIButton *)btn {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(btn.tag, self.editorView.textStore);
    }
}

- (IBAction)bgBtnClick:(id)sender {
    [self.editorView endEditing:YES];
}

@end
