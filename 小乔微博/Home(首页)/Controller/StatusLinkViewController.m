//
//  StatusLinkViewController.m
//  小乔微博
//
//  Created by kenny on 15/7/2.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "StatusLinkViewController.h"
@interface StatusLinkViewController()<UIWebViewDelegate>
@property(nonatomic , strong)UIWebView * webView;
@end

@implementation StatusLinkViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"webLink"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"webLink"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 1. 创建一个webView
    UIWebView * webView = [[UIWebView alloc]init];
    webView.frame  = self.view.bounds;
    webView.delegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    
    NSString * str = self.URL;
    NSURL * url = [NSURL URLWithString:str];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title  = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取当前页面的title
}

- (void)dealloc{
    self.webView =  nil;
    
}

@end
