//
//  HWAttributesLabel.m
//  Oc-Dome
//
//  Created by 李含文 on 2019/4/13.
//  Copyright © 2019年 东莞市三心网络科技有限公司. All rights reserved.
//

#import "HWAttributesLabel.h"

@interface HWAttributesTextView : UITextView


@end
@implementation HWAttributesTextView

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    // 返回NO为禁用，YES为开启
    // 粘贴
    if (action == @selector(paste:)) return NO;
    // 剪切
    if (action == @selector(cut:)) return NO;
    // 复制
    if (action == @selector(copy:)) return NO;
    // 选择
    if (action == @selector(select:)) return NO;
    // 选中全部
    if (action == @selector(selectAll:)) return NO;
    // 删除
    if (action == @selector(delete:)) return NO;
    // 分享
    if (action == @selector(share)) return NO;
    return [super canPerformAction:action withSender:sender];
}

- (BOOL)canBecomeFirstResponder {
    return NO;
}

@end

@interface HWAttributesLabel()<UITextViewDelegate>

/** <#注释#> */
@property(nonatomic, strong) HWAttributesTextView *textView;

@property(nonatomic, copy) NSString *content;

@property(nonatomic, copy)  void(^block)(void);
@end

@implementation HWAttributesLabel

- (void)hw_setAttributesText:(NSMutableAttributedString *)text
                  actionText:(NSString *)actionText
                      action:(void(^)(void))action {
    self.textView.attributedText = text;
    self.content = actionText;
    self.block = action;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction  API_AVAILABLE(ios(10.0)){
    if ([textView.text containsString:self.content]) {
        if (self.block) {
            self.block();
        }
        return NO;
    }
    return YES;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
    [self configuration];
}
- (instancetype)init {
    if (self == [super init]) {
        [self setupUI];
        [self configuration];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupUI];
        [self configuration];
    }
    return self;
}

- (void)configuration {
    self.userInteractionEnabled = YES;
}

- (void)setupUI {
    [self addSubview:self.textView];
}

- (void)layoutSubviews {
    self.textView.frame = self.bounds;
}


- (HWAttributesTextView *)textView {
    if (_textView == nil) {
        _textView = [[HWAttributesTextView alloc]init];
        _textView.backgroundColor = self.backgroundColor;
        _textView.textColor = self.textColor;
        self.textColor = [UIColor clearColor];
        _textView.font = self.font;
        _textView.scrollEnabled = NO;
        _textView.text = self.text;
        _textView.delegate = self;
        _textView.editable = NO;
        _textView.textAlignment = self.textAlignment;
        _textView.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor redColor]};
    }
    return _textView;
}

@end
