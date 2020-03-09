//
//  SpeechViewController.m
//  Oc-Dome
//
//  Created by 李含文 on 2019/4/13.
//  Copyright © 2019年 东莞市三心网络科技有限公司. All rights reserved.
//

#import "SpeechViewController.h"
#import "HWSpeechManage.h"

@interface SpeechViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tf;

@end

@implementation SpeechViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)btn_1Click:(id)sender {
    NSString *content = @"请输入播报内容";
    if (self.tf.text.length != 0) {
        content = _tf.text;
    }
    [HWSpeechManage sharedManage].content = content;
    [[HWSpeechManage sharedManage] start];
}

- (IBAction)btn_2Click:(id)sender {
    NSString *content = @"请输入播报内容";
    if (self.tf.text.length != 0) {
        content = [NSString stringWithFormat:@"支付宝到账%@元",_tf.text];
    }
    [HWSpeechManage sharedManage].content = content;
    [[HWSpeechManage sharedManage] start];
}

@end
