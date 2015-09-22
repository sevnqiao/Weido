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

@interface AppDelegate ()
@property(nonatomic,strong)UIView *launchView;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
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
    
//    _launchView = [[NSBundle mainBundle]loadNibNamed:@"LaunchScreen" owner:nil options:nil].lastObject;
//    _launchView.frame = self.window.frame;
//    [self.window addSubview:_launchView];
//    
//    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 50, 320, 300)];
////    imageV.backgroundColor = [UIColor redColor];
//    NSURL *url = [NSURL URLWithString:@"http://ww4.sinaimg.cn/bmiddle/660f5ef4jw1evnvlysk00j20go0m8tap.jpg"];
//    [imageV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"album"]];
//    [_launchView addSubview:imageV];
//    [self.window bringSubviewToFront:_launchView];
//    
//    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(removeLun) userInfo:nil repeats:NO];

    return YES;
}

- (void)removeLun
{
    [_launchView removeFromSuperview];
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
/**
 *  当app进入后台
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    __block UIBackgroundTaskIdentifier task = [application beginBackgroundTaskWithExpirationHandler:^{
        // 当申请的后台运行时间已近结束,就会调用这个block
        [application endBackgroundTask:task];
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
