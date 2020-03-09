//
//  GCDSocketClientViewController.m
//  Oc-Dome
//
//  Created by 李含文 on 2019/5/25.
//  Copyright © 2019年 东莞市三心网络科技有限公司. All rights reserved.
//

#import "GCDSocketClientViewController.h"
#import "GCDAsyncSocket.h"
#import "PublicTool.h"

@interface GCDSocketClientViewController ()<GCDAsyncSocketDelegate>
@property (weak, nonatomic) IBOutlet UITextField *addrTF;
@property (weak, nonatomic) IBOutlet UITextField *portTF;
@property (weak, nonatomic) IBOutlet UITextField *msgTF;
@property (weak, nonatomic) IBOutlet UITextView *logTV;

@property (nonatomic, strong)GCDAsyncSocket *socket;
@end

@implementation GCDSocketClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToResign:)];
    [self.view addGestureRecognizer:tap];
    [self setupClientSocket];
}

- (void)tapToResign:(UITapGestureRecognizer*)tap{
    [_msgTF resignFirstResponder];
}

- (void)setupClientSocket{
    //在主队列中处理,  所有的回执都在主队列中执行。
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}


- (void)showLogMsg:(NSString*)log{
    _logTV.text = [_logTV.text stringByAppendingFormat:@"%@\n",log];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Event Handle

- (IBAction)connectBtnClick:(id)sender {
    NSError* error = nil;
    if (self.socket == nil) {
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        [self.socket connectToHost:_addrTF.text onPort:_portTF.text.intValue error:&error];
    } else{
        if (![self.socket isConnected]) {
            [self.socket connectToHost:_addrTF.text onPort:_portTF.text.intValue error:&error];
        }
    }
    if (error != nil) {
        [self showLogMsg:@"连接失败..."];
        return;
    }
    [self showLogMsg:@"连接成功..."];
}

- (IBAction)sendBtnClick:(id)sender {
    NSString* strMsg = _msgTF.text;
    [self.socket writeData:[strMsg dataUsingEncoding:NSUTF8StringEncoding] withTimeout:30 tag:100];
    [self showLogMsg:[NSString stringWithFormat:@"你: %@", _msgTF.text]];
    _msgTF.text = @"";
}

#pragma mark - GCDAsyncSocket
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSString* strMsg = @"我是客服端 连接你来了";
    [self.socket writeData:[strMsg dataUsingEncoding:NSUTF8StringEncoding] withTimeout:30 tag:100];
    [self.socket readDataWithTimeout:-1 tag:100];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    [self showLogMsg:@"socket断开连接..."];
}

//注意：要想长连接,必须还要在DidReceiveData的delegate中再写一次[_udpSocket receiveOnce:&error]
//读取信息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSString* strMsg = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    [self showLogMsg:[NSString stringWithFormat:@"服务器: %@",strMsg]];
    [self.socket readDataWithTimeout:-1 tag:100];
}

@end
