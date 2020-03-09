//
//  HWWebViewController.h
//  Oc-Dome
//
//  Created by 李含文 on 2019/1/14.
//  Copyright © 2019年 东莞市三心网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface HWWebViewController : BaseViewController
/** <#注释#> */
@property(nonatomic, strong) NSURL *url;
/** <#注释#> */
@property(nonatomic, strong) WKWebView *webView;
@end

NS_ASSUME_NONNULL_END
