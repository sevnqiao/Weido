//
//  NearByUserTableViewController.m
//  小乔微博
//
//  Created by Sevn on 15/9/30.
//  Copyright © 2015年 Mr.X. All rights reserved.
//

#import "NearByUserTableViewController.h"
#import "MyFansTableViewCell.h"
#import "User.h"
#import "Account.h"
#import "AccountTools.h"
#import "HttpTool.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "MMLocationManager.h"

@interface NearByUserTableViewController ()<UITableViewCellDelegate>
@property(nonatomic,strong)NSMutableArray * dataArr;
@property(nonatomic,assign)CGFloat latitude;
@property(nonatomic,assign)CGFloat longitude;
@property(nonatomic,assign)int page;

@end

@implementation NearByUserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"附近的人";
    _page = 1;
    [self getUserLocation];

    self.tableView.backgroundColor = color(244,243,241);
    
    [self.tableView addHeaderWithTarget:self action:@selector(getPhotoList)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMore)];
  
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
      [self.tableView headerBeginRefreshing];
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


// 获取附近的人
- (void)getPhotoList{
    [MBProgressHUD showMessage:@"正在加载中"];
    NSString *str1 = [NSString stringWithFormat:@"https://api.weibo.com/2/place/nearby/users.json?access_token=2.00PBkLBEU3TPLB3b10a0df3a0ZuXR3&uid=3682106173&lat=%f&long=%f&page=%d",_latitude,_longitude,_page];
    NSURL *url=[NSURL URLWithString:str1];//创建URL
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];//通过URL创建网络请求
    [request setTimeoutInterval:30];//设置超时时间
    [request setHTTPMethod:@"GET"];//设置请求方式
    NSError *err;
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSArray * arr = [NSArray arrayWithArray:rootDic[@"users"]];
    for (NSDictionary * dict in arr) {
        User * user = [User objectWithKeyValues:dict];
        [self.dataArr addObject:user];
    }
    [self.tableView reloadData];
    [MBProgressHUD hideHUD];
    [self.tableView headerEndRefreshing];

}

// 加载更多附近的人
- (void)loadMore{
    _page = _page + 1;
    [MBProgressHUD showMessage:@"正在加载中"];
    NSString *str1 = [NSString stringWithFormat:@"https://api.weibo.com/2/place/nearby/users.json?access_token=2.00PBkLBEU3TPLB3b10a0df3a0ZuXR3&uid=3682106173&lat=%f&long=%f&page=%d",_latitude,_longitude,_page];
    NSURL *url=[NSURL URLWithString:str1];//创建URL
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];//通过URL创建网络请求
    [request setTimeoutInterval:30];//设置超时时间
    [request setHTTPMethod:@"GET"];//设置请求方式
    NSError *err;
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSArray * arr = [NSArray arrayWithArray:rootDic[@"users"]];
    for (NSDictionary * dict in arr) {
        User * user = [User objectWithKeyValues:dict];
        [self.dataArr addObject:user];
    }
    [self.tableView reloadData];
    [MBProgressHUD hideHUD];
    [self.tableView footerEndRefreshing];
}

// 获取用户的位置
- (void)getUserLocation
{
    __block __weak NearByUserTableViewController *weakSelf = self;
    [[MMLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        weakSelf.latitude = locationCorrrdinate.latitude;
        weakSelf.longitude = locationCorrrdinate.longitude;
    } withAddress:^(NSString *addressString) {
        //        weakSelf.addressString = addressString;
        
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
