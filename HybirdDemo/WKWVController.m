//
//  WKWVController.m
//  HybirdDemo
//
//  Created by coolwxb on 2016/12/1.
//  Copyright © 2016年 coolwxb. All rights reserved.
//

#import "WKWVController.h"
#import <WebKit/WebKit.h>
@interface WKWVController ()<WKUIDelegate,WKScriptMessageHandler>

@property (strong, nonatomic) WKWebView *webView;

@end

@implementation WKWVController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // js配置
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addScriptMessageHandler:self name:@"jsCallOC"];
    
    // WKWebView的配置
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = userContentController;

    
    // 显示WKWebView
    _webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds configuration:configuration];
    _webView.UIDelegate = self; // 设置WKUIDelegate代理
    [self.view addSubview:_webView];
    

    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:urlRequest];
    
    
}


// WKScriptMessageHandler protocol?

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"方法名:%@", message.name);
    NSLog(@"参数:%@", message.body);
    // 方法名
    NSString *methods = [NSString stringWithFormat:@"%@", message.name];
    SEL selector = NSSelectorFromString(methods);
    // 调用方法
    if ([self respondsToSelector:selector]) {
        [self performSelector:selector withObject:message.body];
    } else {
        NSLog(@"未实行方法：%@", methods);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (void)jsCallOC{
    [self.webView evaluateJavaScript:@"wkNativeCallJS('嘿嘿')" completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        NSLog(@"我执行完毕");
    }];
}

@end
