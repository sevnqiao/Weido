//
//  OAuthViewController.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/4.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//


#import "OAuthViewController.h"
#import "TabBarViewController.h"
#import "NewFeatureViewController.h"
#import "Account.h"
#import "MBProgressHUD+MJ.h"
#import "AccountTools.h"
#import "count.h"
#import "HttpTool.h"

@interface OAuthViewController ()<UIWebViewDelegate>

@end

@implementation OAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 1. 创建一个webView
    UIWebView * webView = [[UIWebView alloc]init];
    webView.frame  = self.view.bounds;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    // 2. 用webView加载登陆界面(新浪提供的)
    // 请求地址 : https://api.weibo.com/oauth2/authorize
    NSString * str = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@",AppKey,AppredirectURL];
    NSURL * url = [NSURL URLWithString:str];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
}

#pragma mark - webView代理

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showMessage:@"正在加载数据..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUD];
}


/**
 *  webView加载前调用
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
   
    // 1. 获取url
    NSString * url = request.URL.absoluteString;
    // 2. 判断是否为回调地址
    NSRange range = [url rangeOfString:@"code="];
    if (range.length > 0) {// 是回调地址
        // 截取code后的参数值
        int fromIndex = (int)(range.location + range.length);
        NSString * code = [url substringFromIndex:fromIndex];
        
        // 利用code换取一个access_Token
        [self accessTokenWithCode:code];
        
        // 禁止加载回调地址
        return NO;

    }
    
    return YES;
}


/**
 *  利用code(授权成功后的request token)换取一个accessToken
 *
 *  @return 授权成功后的requestToken
 */

/**
 HTTP请求方式
 URL : https://api.weibo.com/oauth2/access_token
 POST
 
 请求参数         必选 	类型及范围 	说明
 client_id 	    true 	string 	申请应用时分配的AppKey。
 client_secret 	true 	string 	申请应用时分配的AppSecret。
 grant_type 	true 	string 	请求的类型，填写authorization_code
 
 
 grant_type为authorization_code
                必选   类型及范围 	说明
 code           true 	string 	调用authorize获得的code值。
 redirect_uri 	true 	string 	回调地址，需需与注册应用里的回调地址一致。
 */

- (void)accessTokenWithCode:(NSString *)code
{
    // 1. 拼接请求参数
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    parms[@"client_id"] = AppKey;
    parms[@"client_secret"] = AppSecret;
    parms[@"grant_type"] = @"authorization_code";
    parms[@"code"] = code;
    parms[@"redirect_uri"] = AppredirectURL;

    // 2. 发送请求
    [HttpTool post:@"https://api.weibo.com/oauth2/access_token" params:parms
           success:^(id json) {
               [MBProgressHUD hideHUD];
               
               // 将返回的账号数据存入沙盒
               Account * account = [Account accountWithDict:json]; // 数据转模型
               [AccountTools saveAccount:account];
               // 3. 切换窗口 进入首页
               // 切换根控制器
               [[UIApplication sharedApplication].keyWindow switchRootViewController];
           } failure:^(NSError *error) {
               [MBProgressHUD hideHUD];
           }];
    

}
@end
