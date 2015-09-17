//
//  UserDetialViewController.m
//  小乔微博
//
//  Created by kenny on 15/7/7.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//
//#define headH 200
//#define headMinH 84
//#define tabBarH 44
#define YZHeadViewH 200

#define YZHeadViewMinH 64

#define YZTabBarH 44

#import "UserDetialViewController.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "Status.h"
#import "StatusCell.h"
#import "StatusFrame.h"
#import "HttpTool.h"
#import "AccountTools.h"
#import "Account.h"
#import "MJExtension.h"
#import "CommentListViewController.h"
#import "MXSliderBar.h"
#import "UIImage+Clip.h"
#import "UIImageView+WebCache.h"


@interface UserDetialViewController ()<StatusCellDelegate>
@property(nonatomic,strong)NSMutableArray *statusesFrame;
@property (nonatomic, assign) CGFloat lastOffsetY;

@property(nonatomic,strong)UILabel *nameL;
@property(nonatomic,strong)UILabel *desL;
@property(nonatomic,strong)UILabel *fansL;
@property(nonatomic,strong)UILabel *attentionL;
@property(nonatomic,strong)UIImageView *iconView;


@property(nonatomic,strong)UILabel *titleLabel;

@end

@implementation UserDetialViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"UserDetial"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"UserDetial"];
    self.navigationController.navigationBar.alpha = 1;
}

-  (NSMutableArray *)statusesFrame {
    if (!_statusesFrame) {
        _statusesFrame = [[NSMutableArray alloc]init];
        
    }
    return _statusesFrame;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _lastOffsetY = -40;
    [self getUserDetail];
    [self.tableView setHeaderHidden:YES];
    [self setUpRefresh];
    [self loadNewStatus];
    [self setupNav];

    self.tableView.tableHeaderView = [self setupHeader];
    self.tableView.backgroundColor = color(221, 221, 221);
}

/**
 *  设置导航栏内容
 */
- (void)setupNav
{
    // 清除导航条默认颜色
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
   
    // 导航条背景透明
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    _titleLabel = [[UILabel alloc]init];
    self.navigationItem.titleView  = _titleLabel;
}

- (UIView *)setupHeader
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, -80, [UIScreen mainScreen].bounds.size.width, 200)];
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -64, [UIScreen mainScreen].bounds.size.width, 264)];
    backImage.image = [UIImage imageNamed:@"IMG_0031"];
    [headerView addSubview:backImage];
    
    UILabel *desL = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(backImage.frame) - 10 -15 + 64, self.view.width, 15)];
    desL.textAlignment = NSTextAlignmentCenter;
    [backImage addSubview:desL];
    desL.font = [UIFont systemFontOfSize:12];
    desL.textColor = [UIColor whiteColor];
    _desL = desL;
    
    UILabel *fansL = [[UILabel alloc]init];
    fansL.x = self.view.width*0.5+5;
    fansL.y = CGRectGetMinY(desL.frame)- 5 - 15;
    fansL.width = self.view.width;
    fansL.height = 15;
    fansL.textAlignment = NSTextAlignmentLeft;
    fansL.font = [UIFont systemFontOfSize:12];
    fansL.textColor = [UIColor whiteColor];
    [backImage addSubview:fansL];
    _fansL = fansL;
    
    UILabel *attentionL = [[UILabel alloc]init];
    attentionL.x = 0;
    attentionL.y = CGRectGetMinY(fansL.frame);
    attentionL.width = self.view.width*0.5-5;
    attentionL.height = 15;
    attentionL.textAlignment = NSTextAlignmentRight;
    attentionL.font = [UIFont systemFontOfSize:12];
    attentionL.textColor = [UIColor whiteColor];
    [backImage addSubview:attentionL];
    _attentionL = attentionL;
    
    UILabel *nameL = [[UILabel alloc]init];
    nameL.width = 200;
    nameL.height = 20;
    nameL.x = (headerView.width - nameL.width)*0.5;
    nameL.y = CGRectGetMinY(fansL.frame) - 5 - 20;
    nameL.font = [UIFont systemFontOfSize:15];
    nameL.textAlignment = NSTextAlignmentCenter;
    nameL.textColor = [UIColor whiteColor];
    [backImage addSubview:nameL];
    _nameL = nameL;
    
    UIImageView *iconView = [[UIImageView alloc]init];
    iconView.width = 60 ;
    iconView.height = 60;
    iconView.x = (headerView.width - iconView.width)*0.5;
    iconView.y = CGRectGetMinY(nameL.frame) - 5 - 60;
    [backImage addSubview:iconView];
    _iconView = iconView;
    
    return headerView;
}

#pragma mark - scrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat delta = offsetY - _lastOffsetY;
    CGFloat alpha;
    // 当alpha大于1，导航条半透明，因此做处理，大于1，就直接=0.99
    
    // 往上拖动，高度减少。
    CGFloat height = 200 - delta - 44;
    if (height > 64)
    {
        alpha = 0;
    }
    else
    {
        alpha = 1 - height / (64);
    }
        if (alpha >= 1) {
        alpha = 0.99;
    }
    UIColor *alphaColor = [UIColor colorWithWhite:0 alpha:alpha];
    [_titleLabel setTextColor:alphaColor];
    
    // 设置导航条背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:244 green:244 blue:244 alpha:alpha]] forBarMetrics:UIBarMetricsDefault];
    
}

/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 */
- (void)getUserDetail
{
    [MBProgressHUD showMessage:@"正在努力加载中..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [XYQApi getUserInfoWithAccessToken:[AccountTools account].access_token screenName:self.userName type:@"GET" success:^(id json) {
            _nameL.text = json[@"name"];
            if ([json[@"description"] isEqualToString:@""]) {
                _desL.text = @"简介 : 这个家伙很懒,什么都没有留下!";
            }else{
                _desL.text = [NSString stringWithFormat:@"简介 : %@",json[@"description"]];
            }
            UIImageView * imageView = [[UIImageView alloc]init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:json[@"profile_image_url"]] placeholderImage:[UIImage imageNamed:@"album"]];
            _iconView.image = [UIImage imageWithImage:imageView.image border:1.0 borderColor:[UIColor clearColor]];
            _attentionL.text =  [NSString stringWithFormat:@"关注数 : %@",[json[@"friends_count"] stringValue]];
            _fansL.text = [NSString stringWithFormat:@"粉丝数 : %@",[json[@"followers_count"] stringValue] ];
            
            [MBProgressHUD hideHUD];

        }];
    });
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
    params[@"screen_name"] = @"熊桥桥桥桥桥桥";
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


///**
// *  集成下拉刷新
// */
//- (void)setDownRefresh
//{
//    [self.tableView addHeaderWithTarget:self action:@selector(loadNewStatus)];
//}
- (void)loadNewStatus
{
    [MBProgressHUD showMessage:@"正在努力加载中"];
    Account * account = [AccountTools account];
    // 2. 拼接请求参数
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"screen_name"] = @"熊桥桥桥桥桥桥";
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
        [MBProgressHUD hideHUD];
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
    cell.indexPath = indexPath;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MXSliderBar *sliderBar = [[MXSliderBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 33) withTitles:@[@"主页",@"微博",@"相册"]];
    sliderBar.backgroundColor = color(242, 242, 242);
    return sliderBar;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 33;
}

- (void)didClickCellCommentWithIndexPath:(int)indexPath
{
    CommentListViewController * com = [[CommentListViewController alloc]init];
    [self.navigationController pushViewController:com animated:YES];
    
    StatusFrame * statusFrame = self.statusesFrame[indexPath];
    com.statusFrame = statusFrame;
}



- (void)dealloc
{
    self.navigationController.navigationBar.alpha = 1;
}

@end
