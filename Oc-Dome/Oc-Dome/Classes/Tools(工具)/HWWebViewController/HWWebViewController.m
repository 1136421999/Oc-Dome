//
//  HWWebViewController.m
//  Oc-Dome
//
//  Created by 李含文 on 2019/1/14.
//  Copyright © 2019年 东莞市三心网络科技有限公司. All rights reserved.
//

#import "HWWebViewController.h"

@interface HWWebViewController ()<WKNavigationDelegate>
/** <#注释#> */
@property(nonatomic, strong) UIView *mainView;
/** <#注释#> */
@property(nonatomic, strong) UIProgressView *progressView;
@end

@implementation HWWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addMainView];
    [self creatWebView];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 添加进度条
- (void)addMainView {
    HWWeakSelf(weakSelf)
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HWScreenW, HWScreenH)];
    mainView.backgroundColor = [UIColor clearColor];
    _mainView = mainView;
    [weakSelf.view addSubview:mainView];
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, HWScreenW, 1)];
    progressView.progress = 0;
    _progressView = progressView;
    [weakSelf.view addSubview:progressView];
}
- (void)creatWebView {
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.navigationDelegate = self;
    _webView.scrollView.bounces = NO;
    [self.mainView addSubview:_webView];
    // 添加观察者
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL]; // 进度
}
- (void)setUrl:(NSURL *)url {
    _url = url;
    HWWeakSelf(weakSelf)
    //    NSURLRequest *request = [NSURLRequest requestWithURL:weakSelf.url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:weakSelf.url];
    // 添加请求头
    //    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];//当前时间距离
    //    NSString *key = [NSString stringWithFormat:@"%.0f0001#j0ZAqg",timeInterval];
    //    [request setValue:[HWDataManager getMD5HashWithMessage:key] forHTTPHeaderField:@"key"];
    //    [request setValue:[NSString stringWithFormat:@"%.0f000", timeInterval] forHTTPHeaderField:@"times"];
    [_webView loadRequest:request];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}
// 页面加载完毕时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    self.title = webView.title;
}
#pragma mark - 监听加载进度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    HWWeakSelf(weakSelf)
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (object == _webView) {
            [weakSelf.progressView setAlpha:1.0f];
            [weakSelf.progressView setProgress:weakSelf.webView.estimatedProgress animated:YES];
            if(weakSelf.webView.estimatedProgress >= 1.0f) {
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [weakSelf.progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [weakSelf.progressView setProgress:0.0f animated:NO];
                }];
            }
        }
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}
// 当对象即将销毁的时候调用
- (void)dealloc {
    NSLog(@"webView释放");
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    _webView.navigationDelegate = nil;
}
#pragma mark - WKNavigationDelegate
#pragma mark - 截取当前加载的URL
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//    HWWeakSelf(weakSelf)
//    NSURL *URL = navigationAction.request.URL;
//    HWLog(@"%@", URL);
//    if (![[NSString stringWithFormat:@"%@", weakSelf.url] isEqualToString:[NSString stringWithFormat:@"%@", URL]]) { // 不相等
//        //        weakSelf.navigationView.titleLabel.text = @"攻略详情";
//        HWStrategyDetailsViewController *vc = [[HWStrategyDetailsViewController alloc] init];
//        vc.url = URL;
//        [weakSelf.navigationController pushViewController:vc animated:YES];
//        //        self.button.hidden = NO;
//        //        _webView.height = HWScreenH-64-50;
//        //        self.collectionButton.hidden = NO;
//        //        self.forwardingButton.hidden = NO;
//        decisionHandler(WKNavigationActionPolicyCancel);
//    }else {
//        weakSelf.navigationView.titleLabel.text = weakSelf.title;
//        decisionHandler(WKNavigationActionPolicyAllow); // 必须实现 不然会崩溃
//    }
//}
@end
