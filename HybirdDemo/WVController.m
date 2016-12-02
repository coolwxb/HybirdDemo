//
//  WVController.m
//  HybirdDemo
//
//  Created by coolwxb on 2016/12/1.
//  Copyright © 2016年 coolwxb. All rights reserved.
//

#import "WVController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjcDelegate <JSExport>

-(void)logInfo:(NSString*)info;

@end



@interface WVController ()<JSObjcDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *wv;
@property (nonatomic, strong) JSContext *jsContext;
@end

@implementation WVController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* path = [[NSBundle mainBundle]pathForResource:@"index" ofType:@"html"];
    NSURL* url = [NSURL URLWithString:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [self.wv loadRequest:request];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    }

//oc调用js
- (IBAction)callJSMethod:(id)sender {
    [self.wv stringByEvaluatingJavaScriptFromString:@"wvNativeCallJS()"];
}

//使用url拦截
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if ([request.URL.scheme isEqualToString:@"callnative"]) {
        NSLog(@"hello world");
        return false;
    }
    return true;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //获取上下文对象
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext[@"Objc"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
    
    
    //直接使用block方式执行oc方法
    self.jsContext[@"logHello"] = ^(){
        NSLog(@"hello");
    };
}

//使用代理接口方式执行native方法
-(void)logInfo:(NSString *)info{
    NSLog(@"js传来的参数%@",info);
    JSValue* callback = self.jsContext[@"wvNativeCallJS"];
    [callback callWithArguments:nil];
}
@end
