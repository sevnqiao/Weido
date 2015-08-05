//
//  BaseTableViewController.m
//  Lottery
//
//  Created by 熊云桥 on 15/5/20.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SettingCell.h"
#import "SettingGroup.h"
#import "SettingArrowItem.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController


- (NSMutableArray *)dataList
{
    if (_dataList == nil) {
        _dataList = [[NSMutableArray alloc]init];
    }
    return _dataList;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // IOS6 适配
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = color(244,243,241);
    
    self.tableView.sectionHeaderHeight = 20 ;
    self.tableView.sectionFooterHeight = 0;
    
    if (IOS7) {
        self.tableView.contentInset = UIEdgeInsetsMake(-15, 0, 0, 0);
    }
    
    
}

// 重写初始化方法
- (instancetype)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}



#pragma mark - data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SettingGroup * arr = self.dataList[section];
    return arr.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建cell
    SettingCell * cell = [SettingCell cellWithTableView:tableView];
    
    // 取出模型
    SettingGroup * group = self.dataList[indexPath.section];
    SettingItem * item = group.items[indexPath.row];
    
    // 传递模型
    cell.item = item;
    
    cell.indexPath = indexPath;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    SettingGroup * group = self.dataList[section];
    return group.header;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    SettingGroup * group = self.dataList[section];
    return group.footer;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 取出模型
    SettingGroup * group = self.dataList[indexPath.section];
    SettingItem * item = group.items[indexPath.row];
    
    // 执行block
    if (item.block) {
        item.block();
        return;
    }
    
    
    if ([item isKindOfClass:[SettingArrowItem class]]) { // 需要跳转
        SettingArrowItem * item1 = (SettingArrowItem *)item;
        
        // 创建跳转的控制器
        if (item1.destVcClass) {
            UIViewController * vc = [[item1.destVcClass alloc]init];
            
            vc.title = item1.title;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
}


@end
