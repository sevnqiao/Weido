//
//  AppDelegate.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/2.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "AppDelegate.h"
#import "OAuthViewController.h"
#import "Account.h"
#import "AccountTools.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"

#import "ShareSDK/ShareSDK.h"

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define _IPHONE80_ 80000

@interface AppDelegate ()
@property(nonatomic,strong)UIView *launchView;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 创建根控制器
    [self setupRootViewController];
    // 初始化启动动画
//    [self setupLaunchAnimation];
    // 初始化友盟统计
//    [self setupUMessage:launchOptions];
    
    // 初始化shareSDK
    [self setupShareSDK];
    return YES;
}
// 创建根控制器
- (void)setupRootViewController{
    // 1. 创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // 2. 显示窗口
    [self.window makeKeyAndVisible];
    // 3. 创建根控制器
    
    // 获取account信息,并判断是否过期
    Account * account = [AccountTools account];
    if (account == nil) // 账号过期
    {
        self.window.rootViewController = [[OAuthViewController alloc]init];
    }
    else
    {// 之前已经登陆成功过
        // 切换根控制器
        [self.window switchRootViewController];
    }
}

// 初始化启动动画
- (void)setupLaunchAnimation{
    _launchView = [[NSBundle mainBundle]loadNibNamed:@"LaunchScreen" owner:nil options:nil].lastObject;
    _launchView.frame = self.window.frame;
    [self.window addSubview:_launchView];
    
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 50, 320, 300)];
    //    imageV.backgroundColor = [UIColor redColor];
    NSURL *url = [NSURL URLWithString:@"http://ww4.sinaimg.cn/bmiddle/660f5ef4jw1evnvlysk00j20go0m8tap.jpg"];
    [imageV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"album"]];
    [_launchView addSubview:imageV];
    [self.window bringSubviewToFront:_launchView];
    
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(removeLun) userInfo:nil repeats:NO];
}
// 移除启动动画
- (void)removeLun{
    [_launchView removeFromSuperview];
}

- (void)setupShareSDK{
    // 初始化第三方平台
    [ShareSDK registerApp:@"ad101ce403c2"];
    
    // 添加新浪微博
    [ShareSDK connectSinaWeiboWithAppKey:@"1082360318" appSecret:@"f7260a99e539e308364edb6b23d42272" redirectUri:@"http://www.sina.com"];
    
//    [ShareSDK connectSinaWeiboWithAppKey:@"1082360318" appSecret:@"f7260a99e539e308364edb6b23d42272" redirectUri:@"http://www.sina.com" weiboSDKCls:[WeiboSDK class]];
    
    //添加腾讯微博应用 注册网址 http://dev.t.qq.com
    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
                                redirectUri:@"http://www.sharesdk.cn"];
}
/*
// 初始化友盟统计
- (void)setupUMessage:(NSDictionary *)launchOptions{
    //set AppKey and LaunchOptions
    [UMessage startWithAppkey:@"your app key" launchOptions:launchOptions];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //register remoteNotification types
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else{
        //register remoteNotification types
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else
    
    //register remoteNotification types
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
#endif
    
    //for log
    [UMessage setLogEnabled:YES];
}

#pragma mark - 友盟回调
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
    
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //如果注册不成功，打印错误信息，可以在网上找到对应的解决方案
    //如果注册成功，可以删掉这个方法
    NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
}
//*/
//#pragma mark - 通知弹出框
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//{
//    //关闭友盟自带的弹出框
//    //    [UMessage setAutoAlert:NO];
//    
//    [UMessage didReceiveRemoteNotification:userInfo];
//    
//    //    self.userInfo = userInfo;
//    //    //定制自定的的弹出框
//    //    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
//    //    {
//    //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
//    //                                                            message:@"Test On ApplicationStateActive"
//    //                                                           delegate:self
//    //                                                  cancelButtonTitle:@"确定"
//    //                                                  otherButtonTitles:nil];
//    //
//    //        [alertView show];
//    //
//    //    }
//}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    [UMessage sendClickReportForRemoteNotification:self.userInfo];
//}




- (void)applicationWillResignActive:(UIApplication *)application {

}
/**
 *  当app进入后台
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
    __block UIBackgroundTaskIdentifier task = [application beginBackgroundTaskWithExpirationHandler:^{
        // 当申请的后台运行时间已近结束,就会调用这个block
        [application endBackgroundTask:task];
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    // 1. 取消下载
    SDWebImageManager * manager = [SDWebImageManager sharedManager];
    [manager cancelAll];
    
    // 2. 清除内存中得所有图片
    [manager.imageCache clearMemory];
}


@end
