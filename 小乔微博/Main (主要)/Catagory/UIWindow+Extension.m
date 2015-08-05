//
//  UIWindow+Extension.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/4.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "TabBarViewController.h"
#import "NewFeatureViewController.h"

@implementation UIWindow (Extension)

- (void)switchRootViewController
{
    // 从沙盒中取出更新前的版本号
    NSString * lastVersion = [[NSUserDefaults standardUserDefaults]objectForKey:@"CFBundleVersion"];
    
    // 取出当前软件的的版本号
    NSString * currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];

    // 比较两次的版本号
    if ([lastVersion isEqualToString:currentVersion])
    {
        // 版本号相同,则直接进入tabBarController
        self.rootViewController = [[TabBarViewController alloc]init];
    }
    else
    {
        // 版本号不相同  则进入 新特性显示区, 并将新版本号存入沙盒
        self.rootViewController = [[NewFeatureViewController alloc]init];
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:@"CFBundleVersion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
