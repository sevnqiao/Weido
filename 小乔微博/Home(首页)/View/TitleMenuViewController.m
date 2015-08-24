//
//  TitleMenuViewController.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/2.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "TitleMenuViewController.h"
#import "Status.h"
#import "User.h"
#import "AccountTools.h"
#import "Account.h"
#import "HttpTool.h"
#import "MMLocationManager.h"
#import "StatusFrame.h"
#import "MJExtension.h"

@interface TitleMenuViewController ()
@property(nonatomic,strong)Account *account;
@property(nonatomic,assign)CGFloat latitude;
@property(nonatomic,assign)CGFloat longitude;
@property(nonatomic,copy)NSString * addressString;
@property(nonatomic,strong)NSMutableArray * statusesFrame;
@end

@implementation TitleMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _statusesFrame = [NSMutableArray array];
    _account = [AccountTools account];
    self.tableView.backgroundColor = color(245, 245, 245);
    
    [self getUserLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"titleMenu";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID ];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"首页";
            break;
        case 1:
            cell.textLabel.text = @"好友圈";
            break;
        case 2:
            cell.textLabel.text = @"我的微博";
            break;
        case 3:
            cell.textLabel.text = @"周边微博";
            break;
        case 4:
            cell.textLabel.text = @"悄悄关注";
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([self.delegate respondsToSelector:@selector(willSelectRow)]) {
        [self.delegate willSelectRow];
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self getAllStatus];
            break;
        case 1:
            [self getbilateralStatus];
            break;
        case 2:
            [self getCurrentUserStatus];
            break;
        case 3:
            [self getNearByStatus];
            break;
        case 4:
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 网络请求
// 获取用户的位置
- (void)getUserLocation
{
    __block __weak TitleMenuViewController *weakSelf = self;
    [[MMLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        weakSelf.latitude = locationCorrrdinate.latitude;
        weakSelf.longitude = locationCorrrdinate.longitude;
    } withAddress:^(NSString *addressString) {
        weakSelf.addressString = addressString;
    }];
}




// 获取最新的公共微博
- (void)getAllStatus
{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"access_token"] = _account.access_token;
//    StatusFrame * firstStatusF = [self.statusesFrame firstObject];
//    if (firstStatusF) {
//        params[@"since_id"] = firstStatusF.status.idstr;
//    }
    params[@"count"] = @(200);
    [HttpTool get:@"https://api.weibo.com/2/statuses/public_timeline.json" params:params success:^(id json) {
        if (json[@"statuses"]) {
            [_statusesFrame removeAllObjects];
        }
        NSArray * newStatus = [Status objectArrayWithKeyValuesArray:json[@"statuses"]];
        // 将status数组转换为frame数组
        NSMutableArray * newFrame = [NSMutableArray array];
        for (Status * status in newStatus) {
            StatusFrame * statusFrame = [[StatusFrame alloc]init];
            statusFrame.status = status;
            [newFrame addObject:statusFrame];
        }
        
        NSRange range = NSMakeRange(0, newFrame.count);
        NSIndexSet * set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statusesFrame insertObjects:newFrame atIndexes:set];
        
        [self clickRowToRefrashStatusesFrameTitle:@"熊桥桥桥桥桥桥"];

    } failure:^(NSError *error) {
        
    }];
    
}

// 获取双向关注用户的微博
- (void)getbilateralStatus
{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"access_token"] = _account.access_token;
    params[@"count"] = @(100);
    
    [HttpTool get:@"https://api.weibo.com/2/statuses/bilateral_timeline.json" params:params success:^(id json) {
        if (json[@"statuses"]) {
            [_statusesFrame removeAllObjects];
        }
        NSArray * arr = [Status objectArrayWithKeyValuesArray:json[@"statuses"]];
        for (Status * status in arr) {
            StatusFrame * statusFrame = [[StatusFrame alloc]init];
            statusFrame.status = status;
            [_statusesFrame addObject:statusFrame];
            
            [self clickRowToRefrashStatusesFrameTitle:@"好友圈"];
        }
    } failure:^(NSError *error) {
        
    }];
}

// 获取自己发布的微博
- (void)getCurrentUserStatus
{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"access_token"] = _account.access_token;
    params[@"count"] = @(100);
    
    [HttpTool get:@"https://api.weibo.com/2/statuses/user_timeline.json" params:params success:^(id json) {
        if (json[@"statuses"]) {
            [_statusesFrame removeAllObjects];
        }
        NSArray * arr = [Status objectArrayWithKeyValuesArray:json[@"statuses"]];
        for (Status * status in arr) {
            StatusFrame * statusFrame = [[StatusFrame alloc]init];
            statusFrame.status = status;
            [_statusesFrame addObject:statusFrame];
            
            [self clickRowToRefrashStatusesFrameTitle:@"我的微博"];
        }
    } failure:^(NSError *error) {
        
    }];
}

// 获取周边的微博
- (void)getNearByStatus
{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"access_token"] = _account.access_token;
    params[@"lat"] = @(self.latitude);
    params[@"long"] = @(self.longitude);
    params[@"count"] = @(50);

    [HttpTool get:@"https://api.weibo.com/2/statuses/public_timeline.json" params:params success:^(id json) {
        if (json[@"statuses"]) {
            [_statusesFrame removeAllObjects];
        }
        NSArray * arr = [Status objectArrayWithKeyValuesArray:json[@"statuses"]];
        for (Status * status in arr) {
            StatusFrame * statusFrame = [[StatusFrame alloc]init];
            statusFrame.status = status;
            [_statusesFrame addObject:statusFrame];
            
            [self clickRowToRefrashStatusesFrameTitle:@"周边微博"];
        }
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - self delegate
- (void)clickRowToRefrashStatusesFrameTitle:(NSString *)title
{
    if ([self.delegate respondsToSelector:@selector(titleMenuviewController:didSelectedRowToRefreshStatusesFrame:title:)]) {
        [self.delegate titleMenuviewController:self didSelectedRowToRefreshStatusesFrame:_statusesFrame  title:title];
    }
}

@end
