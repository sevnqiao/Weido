//
//  AllAttentionTableViewController.m
//  小乔微博
//
//  Created by kenny on 15/7/1.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "AllAttentionTableViewController.h"
#import "MyAttentionViewTableViewCell.h"
#import "User.h"
#import "Account.h"
#import "AccountTools.h"
#import "HttpTool.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"

@interface AllAttentionTableViewController ()
@property(nonatomic,strong)NSMutableArray * dataArr;

@property(nonatomic,copy)NSString * next_cursor;
@end

@implementation AllAttentionTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的关注";
    [self setupMyAttention];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreUser)];
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


- (void)setupMyAttention
{
    [MBProgressHUD showMessage:@"正在加载中..."];
    [XYQApi getMyFriendsListWithAccessToken:[AccountTools account].access_token UID:[AccountTools account].uid TrimStatus:@0 type:@"GET" success:^(id json) {
        NSArray * arr = [NSArray arrayWithArray:json[@"users"]];
        for (NSDictionary * dict in arr) {
            User * user = [User objectWithKeyValues:dict];
            [self.dataArr addObject:user];
        }
        self.next_cursor = json[@"next_cursor"];
        [self.tableView reloadData];
        [MBProgressHUD hideHUD];
    }];
}

// 上啦加载更多
- (void)loadMoreUser
{
    [MBProgressHUD showMessage:@"正在加载中..."];
    [XYQApi getMoreMyFriendsListWithAccessToken:[AccountTools account].access_token UID:[AccountTools account].uid TrimStatus:@0 curson:self.next_cursor type:@"GET" success:^(id json) {
        NSArray * arr = [NSArray arrayWithArray:json[@"users"]];
        for (NSDictionary * dict in arr) {
            User * user = [User objectWithKeyValues:dict];
            [self.dataArr addObject:user];
        }
        self.next_cursor = json[@"next_cursor"];
        [self.tableView reloadData];
        [MBProgressHUD hideHUD];
        // 结束刷新(隐藏footer)
        [self.tableView footerEndRefreshing];
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    XYQLog(@"self.dataArr.count - %lu",(unsigned long)self.dataArr.count);
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"cell";
    MyAttentionViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MyAttentionViewTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    User * user = self.dataArr[indexPath.row];
    cell.user = user;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 55;
}


// 右侧索引列表
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    //索引数组中得内容,跟分组无关
    //索引数组中得下表对应的时分组的下表
    return @[@"A",@"B",@"C",@"D",@"F",@"G",@"H",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    
    //返回carGroup中titel的数组
    //    NSMutableArray * arrayM = [NSMutableArray array];
    //    for (CarGroup * groups in self.carGroups) {
    //        [arrayM addObject:groups.title];
    //    }
    //    return arrayM;
    
    
    
    //KVC
    //用来间接修改或获取对象属性的方式
    //使用KVC获取数值时,如果指定对象不包含keyPath的"键名",会自动进入对象内部查找
    //如果取值的对象是一个数组,返回的同样是一个数组
//    return [self.carGroups valueForKeyPath:@"title"];
}


@end
