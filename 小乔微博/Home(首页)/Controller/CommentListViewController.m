//
//  CommentViewController.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/18.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "CommentListViewController.h"
#import "Account.h"
#import "AccountTools.h"
#import "Status.h"
#import "CommentFrame.h"
#import "HttpTool.h"
#import "Comment.h"
#import "CommentCell.h"
#import "UIImageView+WebCache.h"
#import "User.h"
#import "StatusFrame.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "CommentToolBar.h"
#import "CommentViewController.h"
#import "StatusCell.h"
#import "Test1ViewController.h"
#import "MBProgressHUD+MJ.h"
#import "StatusLinkViewController.h"

@interface CommentListViewController()<CommentToolBarDelegate,StatusCellLinkDelegate>

@property(nonatomic , strong)NSMutableArray * commentsFrame;
@property(nonatomic , strong)CommentToolBar * toolBar;
@property(nonatomic , strong)NSMutableArray * commentStatus;
@property(nonatomic , strong)UIButton * btn1;
@property(nonatomic , strong)UIButton * btn2;
@property(nonatomic , strong)UIButton * btn4;
@end
@implementation CommentListViewController
- (NSMutableArray *)commentStatus
{
    if (!_commentStatus) {
        _commentStatus = [[NSMutableArray alloc]init];
    }
    return _commentStatus;
}
- (NSMutableArray *)commentsFrame
{
    if (!_commentsFrame) {
        _commentsFrame = [[NSMutableArray alloc]init]; 
    }
    return _commentsFrame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    XYQLog(@"%@",self.statusFrame.status.text);
    self.navigationController.navigationBar.alpha = 1;
    self.navigationItem.title = @"评论列表";
    self.tableView.backgroundColor = color(221, 221, 221);
    
    // 下拉刷新
    [self loadNewComments];
    // 上啦加载
    [self setupComment];
    // 3. 添加工具条
    [self setupToolBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background"]]];
    self.navigationController.navigationBar.alpha = 1;
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
}

- (void)setupToolBar
{
    CommentToolBar * toolBar = [[CommentToolBar alloc]init];
    toolBar.delegate = self;
    toolBar.width = self.view.width;
    toolBar.height = 44;
    toolBar.y = self.view.height - self.toolBar.height - 20;
    toolBar.x = 0;
    [self.navigationController.view insertSubview:toolBar belowSubview:self.navigationController.navigationBar];
    self.toolBar = toolBar;
    
}

- (void)setupComment
{
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewComments)];
}

- (void)loadNewComments
{
    [MBProgressHUD showMessage:@"正在加载中..."];
    Account * account = [AccountTools account];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"id"] = self.statusFrame.status.idstr;
    params[@"count"] = [NSString stringWithFormat:@"%d",20];
    CommentFrame * firstCommentsF = [self.commentsFrame firstObject];
    if (firstCommentsF) {
        params[@"since_id"] = firstCommentsF.comment.idstr;
    }
    
    
    [HttpTool get:@"https://api.weibo.com/2/comments/show.json" params:params success:^(id json) {
        NSArray * comments = json[@"comments"];
        
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newCom = [Comment objectArrayWithKeyValuesArray:comments];
        
        
        // 将status数组转换为frame数组
        NSMutableArray * newFrame = [NSMutableArray array];
        for (Comment * comment in newCom) {
            CommentFrame * commentFrame = [[CommentFrame alloc]init];
            commentFrame.comment = comment;
            [newFrame addObject:commentFrame];
        }
        NSRange range = NSMakeRange(0, newFrame.count);
        NSIndexSet * set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.commentsFrame insertObjects:newFrame atIndexes:set];
        // 刷新表格
        [self.tableView reloadData];
        
        [self.tableView headerEndRefreshing];
        
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];

}



#pragma mark - 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else
    {
        if (self.commentsFrame.count == 0) {
            tableView.tableFooterView.hidden = YES;
        }
        else
            tableView.tableFooterView.hidden = NO;
        
        return self.commentsFrame.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
    
        StatusCell * cell = [StatusCell cellWithTableView:tableView];

        cell.linkDelegate = self;
        
        cell.statusFrame = self.statusFrame;
        
        [cell removeToolBar];

        return cell;
    }
    else {
        CommentCell * cell = [CommentCell cellWithTableView:tableView];
        
        cell.commentFrame = self.commentsFrame[indexPath.row];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        StatusFrame * statusframe = self.statusFrame;
        return statusframe.statusHeight - 33;
    }
    else {
        CommentFrame * frame = self.commentsFrame[indexPath.row];
        return frame.commentHeight;
    }
}




- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 33;
    }else
    {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        StatusFrame * statusframe = self.statusFrame;
        [MBProgressHUD showMessage:@"正在加载中..."];
//        Account * account = [AccountTools account];
//        NSMutableDictionary * params = [NSMutableDictionary dictionary];
//        params[@"access_token" ] = account.access_token;
//        params[@"ids"] = self.statusFrame.status.idstr;
//        
//        [HttpTool get:@"https://api.weibo.com/2/statuses/count.json" params:params success:^(id json) {
            UIButton * btn1 = [self setupWithTitle:[NSString stringWithFormat:@"转发 %d",statusframe.status.reposts_count] btnX:0 backColor:[UIColor whiteColor] titleColor:[UIColor grayColor]];
            
            UIButton * btn2 = [self setupWithTitle:[NSString stringWithFormat:@"评论 %d",statusframe.status.comments_count] btnX:[UIScreen mainScreen].bounds.size.width/4 + 1  backColor:[UIColor whiteColor] titleColor:[UIColor blackColor]];
            
            UIButton * btn3 = [self setupWithTitle:@"" btnX:[UIScreen mainScreen].bounds.size.width/4 * 2 backColor:[UIColor whiteColor] titleColor:[UIColor grayColor]];
            UIButton * btn4 = [self setupWithTitle:[NSString stringWithFormat:@"赞 %d",statusframe.status.attitudes_count] btnX:[UIScreen mainScreen].bounds.size.width/4 * 3 backColor:[UIColor whiteColor] titleColor:[UIColor grayColor]];
            [MBProgressHUD hideHUD];
//        } failure:^(NSError *error) {
//            [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
//        }];
//        
        
   
        UIView * header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 35)];
        header.backgroundColor = color(211, 211, 211);
        

 
        UIView * sepLine = [[UIView alloc]initWithFrame:CGRectMake(0, 33, [UIScreen mainScreen].bounds.size.width, 2)];
        sepLine.backgroundColor = color(211, 211, 211);
        [header addSubview:btn1];
        [header addSubview:btn2];
        [header addSubview:btn3];
        [header addSubview:btn4];
        [header addSubview:sepLine];
        return header;
    }
    return nil;
}
- (UIButton *)setupWithTitle:(NSString *)title btnX:(CGFloat)btnX backColor:(UIColor *)color titleColor:(UIColor *)titleColor
{
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(btnX, 0, [UIScreen mainScreen].bounds.size.width/4, 33)];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btn.backgroundColor = color;
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    
    return btn;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 44;
    }
    return 0;
}


#pragma mark - 工具栏点击事件代理
- (void)commentToolBar:(CommentToolBar *)toolBar DidClickButton:(NSUInteger)index
{
    switch (index) {
        case 0: // 拍照
        {
            XYQLog(@"转法");
        }
            break;
        case 1: // 相册
        {
            CommentViewController * comment = [[CommentViewController alloc]init];
            comment.statusID = self.statusFrame.status.idstr;
            UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:comment];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
            break;
              break;
            
        default:
            break;
    }
}

#pragma mark - statusCellLinkDelegate
/**
 *  点击了链接
 */
- (void)didClickStatusCellLinkTypeURL:(NSString *)URL
{
    StatusLinkViewController * linkVC = [[StatusLinkViewController alloc]init];
    linkVC.URL = URL;
    [self.navigationController pushViewController:linkVC animated:YES];
}
/**
 *  点击了电话
 */
- (void)didClickStatusCellLinkTypePhoneNumber:(NSString *)PhoneNumber
{
    XYQLog(@"%@",PhoneNumber);
}
/**
 *  点击了邮箱
 */
- (void)didClickStatusCellLinkTypeEmail:(NSString *)Email
{
    XYQLog(@"%@",Email);
}
/**
 *  点击了用户
 */
- (void)didClickStatusCellLinkTypeAt:(NSString *)At
{
    XYQLog(@"%@",At);
}
/**
 *  点击了话题
 */
- (void)didClickStatusCellLinkTypePoundSign:(NSString *)PoundSign
{
    XYQLog(@"%@",PoundSign);
}

@end
