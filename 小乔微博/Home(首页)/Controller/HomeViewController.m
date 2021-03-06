//
//  HomeViewController.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/2.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "HomeViewController.h"
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
#import "StatusCell.h"
#import "StatusFrame.h"
#import "StatusTool.h"
#import "CommentListViewController.h"
#import "StatusToolBar.h"
#import "CommentViewController.h"
#import "MBProgressHUD+MJ.h"
#import "StatusLinkViewController.h"
#import "UserDetialViewController.h"
#import "StatusPhotoView.h"
#import "Photo.h"
#import "HZPhotoBrowser.h"
#import "RetweetViewController.h"

#import <mach/mach.h>
#import <sys/sysctl.h>

@interface HomeViewController ()<DrapDownMenuDelegate,StatusCellDelegate,StatusCellLinkDelegate,HZPhotoBrowserDelegate,TitleMenuViewControllerDelegate>
/**  微博数组,里面放得都是模型,一个字典代表一条微博 */
@property (nonatomic , strong)NSMutableArray *statusesFrame;


@property(nonatomic,strong)NSArray *photoBroArr;

@property(nonatomic,strong)DrapDownMenu * menu;

@property(nonatomic,strong)UILabel *label;

@property (nonatomic,strong) StatusFrame *statusFrame;

@end

@implementation HomeViewController
- (NSMutableArray *)statusesFrame{
    if (!_statusesFrame) {
        _statusesFrame = [[NSMutableArray alloc]init];
        
    }
    return _statusesFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNewStatus];
    _statusFrame = [[StatusFrame alloc]init];
    self.tableView.backgroundColor = color(244,243,241);
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    _photoBroArr = [NSArray array];
    // 设置导航栏内容
    [self setupNav];
    //获得用户信息 (昵称)
    [self setupUserInfo];

    // 获取微博未读数
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(setupUnreadCount) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    
    // 集成下拉刷新控件
    [self setDownRefresh];
    // 上拉刷新
    [self setUpRefresh];
}

/**  获取微博未读数 */
- (void) setupUnreadCount{
    // 发送请求
    [XYQApi getUnReadCountWithAccesstoken:[AccountTools account].access_token UID:[AccountTools account].uid type:@"GET" success:^(id json) {
        NSString * status = [json[@"status"] description];
        if (IOS8) {
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        }
        if ([status isEqualToString:@"0"]) {
            self.tabBarItem.badgeValue = nil;
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }else{
            self.tabBarItem.badgeValue = status;
            [UIApplication sharedApplication].applicationIconBadgeNumber = status.intValue;
        }
        [MBProgressHUD hideHUD];
    }];

    
}


/**  上拉加载更多的微博数据 */
- (void)setUpRefresh{
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreStatus)];

}

- (void)loadMoreStatus{
    [MBProgressHUD showMessage:@"正在加载更多微博..."];
    
    // 取出最后面的微博（最新的微博，ID最大的微博）
    StatusFrame *lastStatusF = [self.statusesFrame lastObject];
    NSNumber *maxId ;
    if (lastStatusF) {
        // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        // id这种数据一般都是比较大的，一般转成整数的话，最好是long long类型
        maxId =[NSNumber numberWithLongLong:lastStatusF.status.idstr.longLongValue - 1];
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
        
        // 显示最新微博的数量
        [self showNewStatusCount:(int)newStatus.count];
    };
    
    // 2.加载沙盒中的数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"max_id"] = maxId;
    NSArray *statuses = [StatusTool statusesWithParams:params];
    if (statuses.count) {// 将 HWStatus数组 转为 HWStatusFrame数组
        dealingResult(statuses);
        [MBProgressHUD hideHUD];
    } else {
        // 2.发送请求
        [XYQApi getMoreStatusWithAccessToken:[AccountTools account].access_token maxID:maxId type:@"GET" success:^(id json) {
            if (json[@"statuses"] == nil) {
                [MBProgressHUD showMessage:@"暂无更多微博信息..."];
            }
            // 缓存新浪返回的responseObject
            [StatusTool saveStatuses:json[@"statuses"]];
            
            dealingResult(json[@"statuses"]);
            
            [MBProgressHUD hideHUD];
        }];
    }
}


/**  集成下拉刷新 */
- (void)setDownRefresh{
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewStatus)];
}

- (void)loadNewStatus{
    [MBProgressHUD showMessage:@"正在加载最新的微博..."];

    StatusFrame * firstStatusF = [self.statusesFrame firstObject];
    NSNumber *sinceID;
    if (firstStatusF) {
         sinceID = [NSNumber numberWithLongLong:[firstStatusF.status.idstr longLongValue]];
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
        // 显示最新微博的数量
        [self showNewStatusCount:(int)newFrame.count];
         [MBProgressHUD hideHUD];
    };
    
    // 先尝试从数据库中加载数据
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if (firstStatusF) {
        params[@"since_id"] = firstStatusF.status.idstr;
    }
    NSArray * statuses = [StatusTool statusesWithParams:params];
    if (statuses.count) {
        dealingResult(statuses);
    }
    else{
        // 3. 发送请求
        [XYQApi getNewStatusWithAccessToken:[AccountTools account].access_token sinceID:sinceID type:@"GET" success:^(id json) {
            // 缓存新浪返回的responseObject
            [StatusTool saveStatuses:json[@"statuses"]];
            dealingResult(json[@"statuses"]);
            
            self.tabBarItem.badgeValue = nil;
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            [MBProgressHUD hideHUD];
        }];
    }
}


/**  显示最新微博的数量 */
- (void)showNewStatusCount:(int)count{
    
    if (_label) {
        [_label removeFromSuperview];
    }
    
    UILabel * label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.width = KScreen_W;
    label.height = 35;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    _label = label;
    
    if (count == 0)
    {
        label.text = @"没有最新的微博数据,稍后再试";
    }
    else
    {
        label.text = [NSString stringWithFormat:@"共有%d条新的微博数据",count];
    }
    
    label.y = 64 - label.height;
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    // 动画显示提示栏
    [UIView animateWithDuration:1 animations:^{
        label.y += label.height;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveLinear animations:^{
            label.y -= label.height;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}


/**   获得用户信息 (昵称) */
- (void)setupUserInfo{
    [XYQApi getUserInfoWithAccessToken:[AccountTools account].access_token UID:[AccountTools account].uid type:@"GET" success:^(id json) {
        User * user = [User objectWithKeyValues:json];
        UIButton * titleBtn = (UIButton *)self.navigationItem.titleView;
        [titleBtn setTitle: user.name forState:UIControlStateNormal];
        [titleBtn sizeToFit];
        // 存储昵称到沙盒
        Account *account = [AccountTools account];
        account.name = user.name;
        [AccountTools saveAccount:account];
    }];
}


/**  设置导航栏内容 */
- (void)setupNav{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(friendSearch) image:@"navigationbar_friendsearch" highImage:@"navigationbar_friendsearch_highlighted"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(pop:) image:@"navigationbar_pop" highImage:@"navigationbar_pop_highlighted"];
    
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

/**  点击标题事件 */
- (void)titleClick:(UIButton *)titleBtn{
    // 1. 创建menu
    DrapDownMenu * menu = [DrapDownMenu menu];
    menu.delegate = self;
    _menu = menu;
    // 2. 设置内容
    TitleMenuViewController * titleMenu = [[TitleMenuViewController alloc]init];
    titleMenu.delegate = self;
    titleMenu.view.height = 150;
    titleMenu.view.width = 180;
    menu.contentController = titleMenu;
    // 3. 显示
    [menu showFrom:titleBtn];
}

#pragma mark -DrapDownMenuDelegate
/**  下拉菜单销毁 */
- (void)dropdownMenuDidDismiss:(DrapDownMenu *)menu{
    UIButton * titleBtn = (UIButton *)self.navigationItem.titleView;
    [titleBtn setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];

}

/**  下拉菜单显示 */
- (void)dropdownMenuDidShow:(DrapDownMenu *)menu{
    UIButton * titleBtn = (UIButton *)self.navigationItem.titleView;
    [titleBtn setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateNormal];
    
}

#pragma mark - TitleMenuViewControllerDelegate
- (void)willSelectRo{
    
    
//    [_menu dismiss];
//    [MBProgressHUD showMessage:@"努力加载中" toView:[UIApplication sharedApplication].keyWindow];
}

- (void)titleMenuviewController:(TitleMenuViewController *)titleMenuviewController didSelectedRowToRefreshStatusesFrame:(NSMutableArray *)statusesFrame title:(NSString *)title{
    self.statusesFrame = [NSMutableArray arrayWithArray:statusesFrame];
    [self.tableView reloadData];
    
    [_menu dismiss];
    UIButton * titleBtn = (UIButton *)self.navigationItem.titleView;
    [titleBtn setTitle: title forState:UIControlStateNormal];
    [titleBtn sizeToFit];
    
    if ([title isEqualToString:@"熊桥桥桥桥桥桥"]) {
        // 集成下拉刷新控件
        [self setDownRefresh];
        // 上拉刷新
        [self setUpRefresh];
    }
    else
    {
        [self.tableView removeHeader];
        [self.tableView removeFooter];
    }
}

#pragma mark - NavegationBarButton click
- (void)friendSearch{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"剩余内存" message:[NSString stringWithFormat:@"手机剩余内存%.1f \n 当前应用所占内存%.1f",[self availableMemory],[self usedMemory]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)pop:(UIButton *)sender{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"测试一下"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.mob.com"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    XYQLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    XYQLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                }
                            }];
    
}


// 获取当前设备可用内存(单位：MB）
- (double)availableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}

// 获取当前任务所占用的内存（单位：MB）
- (double)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    
    return taskInfo.resident_size / 1024.0 / 1024.0;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StatusCell * cell = [StatusCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.linkDelegate = self;
    cell.statusFrame = self.statusesFrame[indexPath.row];
    cell.indexPath = indexPath;
    return cell;
}

/*- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (self.statusesFrame.count == 0 || self.tableView.tableFooterView.isHidden == NO) {
//        return;
//    }
//    
//    CGFloat offsetY = scrollView.contentOffset.y;
//    
//    CGFloat judgeOffsetY = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.height - self.tableView.tableFooterView.height;
//    
//    if (offsetY >= judgeOffsetY) {
//        self.tableView.tableFooterView.hidden = NO;
//        
//        [self loadMoreStatus];
//    }
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    StatusFrame * frame = self.statusesFrame[indexPath.row];
    return frame.statusHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentListViewController * comment = [[CommentListViewController alloc]init];
    [self.navigationController pushViewController:comment animated:YES];
    StatusFrame * statusFrame = self.statusesFrame[indexPath.row];
    comment.statusFrame = statusFrame;
}


#pragma mark- statusCellDelegate
- (void)didClickCellCommentWithIndexPath:(NSIndexPath *)indexPath WithType:(int)type{
    switch (type) {
        case 100:
        {
            RetweetViewController *ret = [[RetweetViewController alloc]init];
            NavigationController * nav = [[NavigationController alloc]initWithRootViewController:ret];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
            StatusFrame * statusFrame = self.statusesFrame[indexPath.row];
            ret.statusID = statusFrame.status.idstr;
            ret.statusFrame = statusFrame;
        }
            break;
        case 101:
        {
            CommentListViewController * com = [[CommentListViewController alloc]init];
            [self.navigationController pushViewController:com animated:YES];
            StatusFrame * statusFrame = self.statusesFrame[indexPath.row];
            com.statusFrame = statusFrame;
        }
            break;
        case 102:
            
            break;
            
        default:
            break;
    }
    
}

- (void)didClickPhotoWithObjects:(int)index withPhotosArr:(NSArray *)photos WithImageView:(UIImageView *)imageView WithIndexPath:(NSIndexPath *)indexpath{
    self.photoBroArr = photos;
    
    //启动图片浏览器
    HZPhotoBrowser *browserVc = [[HZPhotoBrowser alloc] init];
    browserVc.sourceImagesContainerView = imageView.superview; // 原图的父控件
    browserVc.imageCount = photos.count; // 图片总数
    browserVc.currentImageIndex = index;
    browserVc.delegate = self;
    [browserVc show];
    
    _statusFrame = self.statusesFrame[indexpath.row];
}

#pragma mark - statusCellLinkDelegate
/**  点击了链接 */
- (void)didClickStatusCellLinkTypeURL:(NSString *)URL{   XYQLog(@"%@",URL);
    StatusLinkViewController * linkVC = [[StatusLinkViewController alloc]init];
    linkVC.URL = URL;
    [self.navigationController pushViewController:linkVC animated:YES];
}

/**  点击了电话*/
- (void)didClickStatusCellLinkTypePhoneNumber:(NSString *)PhoneNumber{
    XYQLog(@"%@",PhoneNumber);
}

/**  点击了邮箱*/
- (void)didClickStatusCellLinkTypeEmail:(NSString *)Email{
    XYQLog(@"%@",Email);
}

/** 点击了用户*/
- (void)didClickStatusCellLinkTypeAt:(NSString *)At{
    UserDetialViewController * user = [[UserDetialViewController alloc]init];
    user.userName = [At substringFromIndex:1];
    [self.navigationController pushViewController:user animated:YES];
}

/**  点击了话题 */
- (void)didClickStatusCellLinkTypePoundSign:(NSString *)PoundSign{
    XYQLog(@"%@",PoundSign);
}


#pragma mark - HZPhotoBrowserDelegate
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    NSString *urlStr = [self.photoBroArr[index] thumbnail_pic];
    
    UIImageView * imageView = [[UIImageView alloc]init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];

    return imageView.image;
}

- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    NSString *urlStr = [[self.photoBroArr[index] thumbnail_pic] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"large"];
    return [NSURL URLWithString:urlStr];
}

- (NSString *)photoBrowser:(HZPhotoBrowser *)browser descriptionForIndex:(NSInteger)index
{
    Status *status = _statusFrame.status;
    return status.text;
}


@end
