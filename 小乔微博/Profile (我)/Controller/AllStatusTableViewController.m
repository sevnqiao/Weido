//
//  AllStatusTableViewController.m
//  小乔微博
//
//  Created by kenny on 15/7/1.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "AllStatusTableViewController.h"
#import "DrapDownMenu.h"
#import "TitleMenuViewController.h"
#import "HttpTool.h"
#import "Account.h"
#import "AccountTools.h"
#import "TitleButton.h"
#import "UIImageView+WebCache.h"
#import "User.h"
#import "Status.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "StatusCell.h"
#import "StatusFrame.h"
#import "StatusTool.h"
#import "CommentListViewController.h"
#import "StatusToolBar.h"
#import "CommentViewController.h"

@interface AllStatusTableViewController ()<DrapDownMenuDelegate,StatusCellDelegate>
/**
 *  微博数组,里面放得都是模型,一个字典代表一条微博
 */
@property (nonatomic , strong)NSMutableArray *statusesFrame;
@end

@implementation AllStatusTableViewController

- (NSMutableArray *)statusesFrame
{
    if (!_statusesFrame) {
        _statusesFrame = [[NSMutableArray alloc]init];
        
    }
    return _statusesFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNewStatus];
    
    self.tableView.backgroundColor = color(221, 221, 221);
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    // 设置导航栏内容
    [self setupNav];
    // 集成下拉刷新控件
    [self setDownRefresh];
    // 上拉刷新
    [self setUpRefresh];
    
}


/**
 *  上拉加载更多的微博数据
 */
- (void)setUpRefresh
{
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreStatus)];
    
}
- (void)loadMoreStatus
{
    [MBProgressHUD showMessage:@"正在努力加载中"];
    // 1.拼接请求参数
    Account *account = [AccountTools account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    // 取出最后面的微博（最新的微博，ID最大的微博）
    StatusFrame *lastStatusF = [self.statusesFrame lastObject];
    if (lastStatusF) {
        // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        // id这种数据一般都是比较大的，一般转成整数的话，最好是long long类型
        long long maxId = lastStatusF.status.idstr.longLongValue - 1;
        params[@"max_id"] = @(maxId);
    }
    void (^dealingResult)(NSArray *) = ^(NSArray * statuses){
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatus = [Status objectArrayWithKeyValuesArray:statuses];
        
        // 将status数组转换为frame数组
        NSMutableArray * newFrame = [NSMutableArray array];
        for (Status * status in newStatus) {
            StatusFrame * statusFrame = [[StatusFrame alloc]init];
            statusFrame.status = status;
            [newFrame addObject:statusFrame];
        }
        
        // 将更多的微博数据，添加到总数组的最后面
        [self.statusesFrame addObjectsFromArray:newFrame];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新(隐藏footer)
        [self.tableView footerEndRefreshing];
        
    };
    
    // 2.发送请求
    [HttpTool get:@"https://api.weibo.com/2/statuses/user_timeline.json" params:params success:^(id json) {
        
        dealingResult(json[@"statuses"]);
        
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];
    
}


/**
 *  集成下拉刷新
 */
- (void)setDownRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewStatus)];
}
- (void)loadNewStatus
{
    [MBProgressHUD showMessage:@"正在努力加载中"];
    Account * account = [AccountTools account];
    // 2. 拼接请求参数
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    StatusFrame * firstStatusF = [self.statusesFrame firstObject];
    if (firstStatusF) {
        params[@"since_id"] = firstStatusF.status.idstr;
    }
    
    void (^dealingResult)(NSArray *) = ^(NSArray * statuses){
        NSArray * newStatus = [Status objectArrayWithKeyValuesArray:statuses];
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
        // 刷新表格
        [self.tableView reloadData];
        // 结束刷新
        [self.tableView headerEndRefreshing];

    };
    // 3. 发送请求
    [HttpTool get:@"https://api.weibo.com/2/statuses/user_timeline.json" params:params success:^(id json) {
        dealingResult(json[@"statuses"]);
        self.tabBarItem.badgeValue = nil;
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];
}

/**
 *  设置导航栏内容
 */
- (void)setupNav
{
    TitleButton * titleBtn = [[TitleButton alloc]init];
    //    titleBtn.width = 10;
    //    titleBtn.height = 30;
    // 设置图片和文字
    
    NSString * name = [AccountTools account].name;
    [titleBtn setTitle:name?name:@"首页" forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
    [titleBtn sizeToFit];
}

/**
 *  点击标题事件
 */
- (void)titleClick:(UIButton *)titleBtn
{
    // 1. 创建menu
    DrapDownMenu * menu = [DrapDownMenu menu];
    menu.delegate = self;
    // 2. 设置内容
    TitleMenuViewController * titleMenu = [[TitleMenuViewController alloc]init];
    titleMenu.view.height = 150;
    titleMenu.view.width = 180;
    menu.contentController = titleMenu;
    // 3. 显示
    [menu showFrom:titleBtn];
}
#pragma mark -DrapDownMenuDelegate
/**
 *  下拉菜单销毁
 */
- (void)dropdownMenuDidDismiss:(DrapDownMenu *)menu
{
    UIButton * titleBtn = (UIButton *)self.navigationItem.titleView;
    [titleBtn setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    
}
/**
 *  下拉菜单显示
 */
- (void)dropdownMenuDidShow:(DrapDownMenu *)menu
{
    UIButton * titleBtn = (UIButton *)self.navigationItem.titleView;
    [titleBtn setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateNormal];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    if (self.statusesFrame.count == 0) {
        tableView.tableFooterView.hidden = YES;
    }
    else
        tableView.tableFooterView.hidden = NO;
    
    return self.statusesFrame.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StatusCell * cell = [StatusCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.statusFrame = self.statusesFrame[indexPath.row];
    cell.row = (int)indexPath.row;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StatusFrame * frame = self.statusesFrame[indexPath.row];
    return frame.statusHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentListViewController * comment = [[CommentListViewController alloc]init];
    [self.navigationController pushViewController:comment animated:YES];
    
    
    StatusFrame * statusFrame = self.statusesFrame[indexPath.row];
    
    comment.statusFrame = statusFrame;
    
    
}


#pragma mark- statusCellDelegate
- (void)didClickCellCommentWithIndexPath:(int)indexPath
{
    CommentListViewController * com = [[CommentListViewController alloc]init];
    [self.navigationController pushViewController:com animated:YES];
    
    StatusFrame * statusFrame = self.statusesFrame[indexPath];
    com.statusFrame = statusFrame;
}

@end
