//
//  ProfileViewController.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/2.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//
#import "ProfileViewController.h"
#import "SettingItem.h"
#import "SettingGroup.h"
#import "SettingCell.h"
#import "SettingArrowItem.h"
#import "SettingSwitchItem.h"
#import "Test1ViewController.h"
#import "MBProgressHUD+MJ.h"
#import "SettingTableViewController.h"
#import "ProfileHeaderView.h"
#import "Account.h"
#import "AccountTools.h"
#import "HttpTool.h"
#import "AllStatusTableViewController.h"
#import "AllAttentionTableViewController.h"
#import "AllFansTableViewController.h"
#import "UserDetialViewController.h"

@interface ProfileViewController ()<ProfileHeaderViewDelegate>
@property(nonatomic, strong)NSDictionary * profile;

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.navigationItem.title = @"我";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setting)];
    
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    
    // 0组
    [self addGroup0];
    
    // 1组
    [self addGroup1];
    
    // 2组
    [self addGroup2];
    
    // 3组
    [self addGroup3];
    
    // 4组
    [self addGroup4];
    
    // 获取个人信息
    [self setupProfile];
}

- (void)setupProfile
{
    ProfileHeaderView * header = [[ProfileHeaderView alloc]init];
    header.delegate = self;
    self.tableView.tableHeaderView = header;
}

- (void)setting
{
    // 清除缓存
    //    [[SDImageCache sharedImageCache] clearDisk];
    
    SettingTableViewController * setting = [[SettingTableViewController alloc]init];
    [self.navigationController pushViewController:setting animated:YES];
}

- (void)addGroup0
{
    // 第0组
    SettingArrowItem * item0 = [SettingArrowItem itemWithIcon:@"new_friend" withTitle:@"新的好友" destVcClass:[Test1ViewController class]];
//    SettingArrowItem * item1 = [SettingArrowItem itemWithIcon:nil withTitle:@"微博等级" destVcClass:[Test1ViewController class]];
//    SettingArrowItem * item2 = [SettingArrowItem itemWithIcon:nil withTitle:@"编辑资料" destVcClass:[Test1ViewController class]];
    SettingGroup * group = [[SettingGroup alloc]init];
    group.items = @[item0];
    [self.dataList addObject:group];
}

- (void)addGroup1
{
    // 第一组
    SettingArrowItem * item1 = [SettingArrowItem itemWithIcon:@"album" withTitle:@"我的相册" ];

    
    
    SettingArrowItem * item2 = [SettingArrowItem itemWithIcon:@"collect" withTitle:@"我的点评" destVcClass:[Test1ViewController class]];
    
    SettingArrowItem * item3 = [SettingArrowItem itemWithIcon:@"like" withTitle:@"我的赞" destVcClass:[Test1ViewController class]];
    
    SettingGroup * group = [[SettingGroup alloc]init];
    group.items = @[item1,item2,item3];
    
    [self.dataList addObject:group];
}
- (void)addGroup2
{
    // 第一组
    SettingArrowItem * item1 = [SettingArrowItem itemWithIcon:@"pay" withTitle:@"微博支付" ];
    // block 保存了一段检查更新的功能
    item1.block = ^{
        
    };
    
    
    SettingArrowItem * item2 = [SettingArrowItem itemWithIcon:@"vip" withTitle:@"个性化" destVcClass:[Test1ViewController class]];
    

    
    SettingGroup * group = [[SettingGroup alloc]init];
    group.items = @[item1,item2];
    
    [self.dataList addObject:group];
}

- (void)addGroup3
{
    // 第0组
    SettingArrowItem * item0 = [SettingArrowItem itemWithIcon:@"draft" withTitle:@"草稿箱" destVcClass:[Test1ViewController class]];
    SettingGroup * group = [[SettingGroup alloc]init];
    group.items = @[item0];
    [self.dataList addObject:group];
}

- (void)addGroup4
{
    // 第0组
    SettingArrowItem * item0 = [SettingArrowItem itemWithIcon:@"card" withTitle:@"更多" destVcClass:[Test1ViewController class]];
    SettingGroup * group = [[SettingGroup alloc]init];
    group.items = @[item0];
    [self.dataList addObject:group];
}

#pragma mark - ProfileHeaderViewDelegate
- (void)setupMyDetialDidFinishTap
{
    UserDetialViewController * userVC = [[UserDetialViewController alloc]init];
    [self.navigationController pushViewController:userVC animated:YES];
}

- (void)setupMyStatusDetailDidFinishTap
{
    AllStatusTableViewController * allStatus = [[AllStatusTableViewController alloc]init];
    [self.navigationController pushViewController:allStatus animated:YES];

}
- (void)setupMyAttentionDetailDidFinishTap
{
    AllAttentionTableViewController * allStatus = [[AllAttentionTableViewController alloc]init];
    [self.navigationController pushViewController:allStatus animated:YES];
}
- (void)setupMyFansDetailDidFinishTap
{
    AllFansTableViewController * allStatus = [[AllFansTableViewController alloc]init];
    [self.navigationController pushViewController:allStatus animated:YES];
}

@end
