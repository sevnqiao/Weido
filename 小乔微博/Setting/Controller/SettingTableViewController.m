//
//  SettingTableViewController.m
//  Lottery
//
//  Created by 熊云桥 on 15/5/19.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "SettingTableViewController.h"
#import "SettingItem.h"
#import "SettingGroup.h"
#import "SettingCell.h"
#import "SettingArrowItem.h"
#import "SettingSwitchItem.h"
#import "MBProgressHUD+MJ.h"
#import "Test1ViewController.h"

@interface SettingTableViewController ()


@end

@implementation SettingTableViewController

- (void)viewDidLoad
{
    self.navigationItem.title = @"设置";
    
    [super viewDidLoad];
    
    // 0组
    [self addGroup0];
    
    // 1组
    [self addGroup1];
    
    // 2组
    [self addGroup2];
    
    
}

- (void)addGroup0
{
    // 第0组
    SettingArrowItem * item0 = [SettingArrowItem itemWithIcon:nil withTitle:@"账号管理" destVcClass:[Test1ViewController class]];
    SettingGroup * group = [[SettingGroup alloc]init];
    group.items = @[item0];
    [self.dataList addObject:group];
}

- (void)addGroup1
{
    // 第一组
    SettingArrowItem * item1 = [SettingArrowItem itemWithIcon:nil withTitle:@"通知" ];
    // block 保存了一段检查更新的功能
    item1.block = ^{
        // 1. 显示蒙版
        [MBProgressHUD showMessage:@"正在检查更新..."];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 2. 隐藏蒙版
            [MBProgressHUD hideHUD];
            // 3. 提示用户
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"有更新的版本" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"立即更新", nil];
            [alertView show];
        });
    };
    
    
    SettingArrowItem * item2 = [SettingArrowItem itemWithIcon:nil withTitle:@"隐私与安全" destVcClass:[Test1ViewController class]];

    SettingArrowItem * item3 = [SettingArrowItem itemWithIcon:nil withTitle:@"通用设置" destVcClass:[Test1ViewController class]];
    
    SettingGroup * group = [[SettingGroup alloc]init];
    group.items = @[item1,item2,item3];
    
    [self.dataList addObject:group];
}
- (void)addGroup2
{
    // 第一组
    SettingArrowItem * item1 = [SettingArrowItem itemWithIcon:nil withTitle:@"清理缓存" ];
    // block 保存了一段检查更新的功能
    item1.block = ^{

    };
    
    
    SettingArrowItem * item2 = [SettingArrowItem itemWithIcon:nil withTitle:@"意见反馈" destVcClass:[Test1ViewController class]];
    
    SettingArrowItem * item3 = [SettingArrowItem itemWithIcon:nil withTitle:@"关于微博" destVcClass:[Test1ViewController class]];
    
    SettingGroup * group = [[SettingGroup alloc]init];
    group.items = @[item1,item2,item3];
    
    [self.dataList addObject:group];
}



@end
