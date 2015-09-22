//
//  AllFansTableViewController.m
//  小乔微博
//
//  Created by kenny on 15/7/1.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "AllFansTableViewController.h"
#import "MyFansTableViewCell.h"
#import "User.h"
#import "Account.h"
#import "AccountTools.h"
#import "HttpTool.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"

@interface AllFansTableViewController ()<UITableViewCellDelegate>
@property(nonatomic,strong)NSMutableArray * dataArr;

@property(nonatomic,copy)NSString * next_cursor;
@end

@implementation AllFansTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的Fans";
    [self setupMyAttention];
//    self.next_cursor = @"20";
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreUser)];
    self.tableView.backgroundColor = color(244,243,241);
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
    [XYQApi getMyFansListWithAccessToken:[AccountTools account].access_token
                                     UID:[AccountTools account].uid TrimStatus:@0 count:@200 type:@"GET" success:^(id json) {
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
    [XYQApi getMoreMyFansListWithAccessToken:[AccountTools account].access_token UID:[AccountTools account].uid TrimStatus:@0 curson:@50 count:@200 type:@"GET" success:^(id json) {
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
    MyFansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MyFansTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    User * user = self.dataArr[indexPath.row];
    cell.user = user;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70;
}

//
//// 右侧索引列表
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    //索引数组中得内容,跟分组无关
//    //索引数组中得下表对应的时分组的下表
//    return @[@"A",@"B",@"C",@"D",@"F",@"G",@"H",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
//    
//    //返回carGroup中titel的数组
//    //    NSMutableArray * arrayM = [NSMutableArray array];
//    //    for (CarGroup * groups in self.carGroups) {
//    //        [arrayM addObject:groups.title];
//    //    }
//    //    return arrayM;
//    
//    
//    
//    //KVC
//    //用来间接修改或获取对象属性的方式
//    //使用KVC获取数值时,如果指定对象不包含keyPath的"键名",会自动进入对象内部查找
//    //如果取值的对象是一个数组,返回的同样是一个数组
//    //    return [self.carGroups valueForKeyPath:@"title"];
//}



#pragma mark - UITableViewCellDelegate
/**  取消关注 */
- (void)cancelAttentionWithIdStr:(NSString *)idstr
{
    [XYQApi cancelAttentionWithAccessToken:[AccountTools account].access_token UID:idstr type:@"GET" success:^(id json) {
        [MBProgressHUD showSuccess:@"取消关注成功"];
    }];
}
/**  添加关注 */
- (void)addAttentionWithIdStr:(NSString *)idstr
{
    [XYQApi addAttentionWithAccessToken:[AccountTools account].access_token UID:idstr type:@"GET" success:^(id json) {
        [MBProgressHUD showSuccess:@"添加关注成功"];
    }];
}

@end
