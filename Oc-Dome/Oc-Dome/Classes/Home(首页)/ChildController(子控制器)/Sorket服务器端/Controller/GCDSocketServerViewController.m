//
//  GCDSocketServerViewController.m
//  Oc-Dome
//
//  Created by 李含文 on 2019/5/25.
//  Copyright © 2019年 东莞市三心网络科技有限公司. All rights reserved.
//

#import "GCDSocketServerViewController.h"
#import "GCDAsyncSocket.h"
#import "PublicTool.h"

#import <ifaddrs.h>
#import <arpa/inet.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreTelephony/CTCellularData.h>

@interface GCDSocketServerViewController ()<GCDAsyncSocketDelegate>
@property (weak, nonatomic) IBOutlet UITextField *portTF;
@property (weak, nonatomic) IBOutlet UITextField *msgTF;
@property (weak, nonatomic) IBOutlet UITextView *logTV;

@property (weak, nonatomic) IBOutlet UILabel *ipLabel;


@property (nonatomic, strong)GCDAsyncSocket *serverSocket;
@property (nonatomic, strong)GCDAsyncSocket *clientSocket;


@property (nonatomic, strong)NSMutableArray *clientArr;//连接池
@property (nonatomic, strong)NSMutableArray *clientInfoArr;//客户端信息

@end

@implementation GCDSocketServerViewController

- (NSMutableArray*)clientArr{
    if (_clientArr == nil) {
        _clientArr = [NSMutableArray array];
    }
    return _clientArr;
}

- (NSMutableArray*)clientInfoArr{
    if (_clientInfoArr == nil) {
        _clientInfoArr = [NSMutableArray array];
    }
    return _clientInfoArr;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToResign:)];
    [self.view addGestureRecognizer:tap];
    [self setupServerSocket];
    NSString *wifiName = [self getCurreWiFiSsid];
    NSString *ip = [self getCurrentLocalIP];
    self.ipLabel.text = [NSString stringWithFormat:@"WIFI:%@ IP:%@", wifiName, ip];
}

- (void)tapToResign:(UITapGestureRecognizer*)tap{
    [_msgTF resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupServerSocket{
    //在主线程里面回调
    self.serverSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)showLogMsg:(NSString*)log{
    _logTV.text = [_logTV.text stringByAppendingFormat:@"%@\n",log];
}


#pragma mark - Event Handle
- (IBAction)btnListenClick:(id)sender {//监听
    NSError* error = nil;
    [self.serverSocket acceptOnPort:_portTF.text.intValue error:&error];
    if (error != nil) {
        NSLog(@"监听出错：%@",error);
    }
    else{
        [self showLogMsg:@"正在监听..."];
    }
}

- (IBAction)btnSendClick:(id)sender {
    [self showLogMsg:[NSString stringWithFormat:@"你: %@",_msgTF.text]];
    NSData* data = [_msgTF.text dataUsingEncoding:NSUTF8StringEncoding];
    //给对应的客户端发送数据
    [self.clientSocket writeData:data withTimeout:-1 tag:0];
    _msgTF.text = @"";
}


#pragma mark - GCDAsyncSocketDelegate

//接收到请求
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{
    [self showLogMsg:@"收到客户端连接...."];
    NSString *ip = newSocket.connectedHost;
    int port = newSocket.connectedPort;
    [self showLogMsg:[NSString stringWithFormat:@"客户端地址：%@,客户端端口：%d",ip,port]];
    
    
    //收到连接，保存连接到连接池
    NSMutableDictionary* dicClient = [NSMutableDictionary dictionary];
    [dicClient setValue:newSocket forKey:@"socket"];
    [dicClient setValue:newSocket.connectedHost forKey:@"host"];
    
    //排重
    int tempI = -1;
    for (int i=0; i<self.clientArr.count; i++) {
        NSDictionary* client = [self.clientArr objectAtIndex:i];
        if ([client[@"host"] isEqualToString:newSocket.connectedHost]) {
            tempI = i;
        }
    }
    if (tempI >= 0) {
        [self.clientArr removeObjectAtIndex:tempI];
    }
    [self.clientArr addObject:dicClient];
    self.clientSocket = newSocket;
    [newSocket readDataWithTimeout:-1 tag:0];
    [self showLogMsg:[NSString stringWithFormat:@"你: %@",@"你连接成功了,大兄弟"]];
    NSData* data = [@"你连接成功了,大兄弟" dataUsingEncoding:NSUTF8StringEncoding];
    //给对应的客户端发送数据
    [self.clientSocket writeData:data withTimeout:-1 tag:0];
}

//读取信息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSString* strMsg = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    [self showLogMsg:[NSString stringWithFormat:@"客户端:%@",strMsg]];
    [sock readDataWithTimeout:-1 tag:0];
}

- (nullable NSString*)getCurrentLocalIP {
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}
- (nullable NSString *)getCurreWiFiSsid {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    return [(NSDictionary*)info objectForKey:@"SSID"];
}
@end
