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
#import "RestoreCommentViewController.h"
#import "RetweetViewController.h"
#import "UserDetialViewController.h"

@interface CommentListViewController()<CommentToolBarDelegate,StatusCellLinkDelegate,CommentCellLinkDelegate,UIActionSheetDelegate>

@property(nonatomic , strong)NSMutableArray * commentsFrame;
@property(nonatomic , strong)CommentToolBar * toolBar;
@property(nonatomic , strong)NSMutableArray * commentStatus;
@property(nonatomic , strong)UIButton * btn1;
@property(nonatomic , strong)UIButton * btn2;
@property(nonatomic , strong)UIButton * btn4;
/**
 *  回复评论的ID
 */
@property(nonatomic,copy)NSString *idstr;
/**
 *  需要删除的评论的indexPath
 */
@property(nonatomic,strong)NSIndexPath *indexPath;
@end
@implementation CommentListViewController
- (NSMutableArray *)commentStatus{
    if (!_commentStatus) {
        _commentStatus = [[NSMutableArray alloc]init];
    }
    return _commentStatus;
}
- (NSMutableArray *)commentsFrame{
    if (!_commentsFrame) {
        _commentsFrame = [[NSMutableArray alloc]init]; 
    }
    return _commentsFrame;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    self.navigationController.navigationBar.alpha = 1;
    self.navigationItem.title = @"评论列表";
    
    self.tableView.backgroundColor = color(244,243,241);
//    [self.tableView setContentOffset:CGPointMake(0, self.statusFrame.statusHeight)];
    NSLog(@"%f",self.tableView.contentOffset.y);
    // 下拉刷新
    [self loadNewComments];
    // 上啦加载
    [self addRefresh];
    // 3. 添加工具条
    [self setupToolBar];
    
    
}

- (void)setupToolBar{
    CommentToolBar * toolBar = [[CommentToolBar alloc]init];
    toolBar.delegate = self;
    toolBar.width = self.view.width;
    toolBar.height = 44;
    toolBar.y = self.view.height - self.toolBar.height - 20;
    toolBar.x = 0;
    [self.navigationController.view insertSubview:toolBar belowSubview:self.navigationController.navigationBar];
    self.toolBar = toolBar;
    
}

- (void)addRefresh{
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewComments)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreComments)];
}

- (void)loadNewComments{
    CommentFrame * firstCommentsF = [self.commentsFrame firstObject];
    NSNumber *sinceID;
    if (firstCommentsF) {
        sinceID = [NSNumber numberWithLongLong:[firstCommentsF.comment.idstr longLongValue]];
    }
    
    [XYQApi getNewCommentsWithAccessToken:[AccountTools account].access_token statusID:_statusFrame.status.idstr count:[NSString stringWithFormat:@"%d",20] sinceID:sinceID type:@"GET" success:^(id json) {
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
    }];
}
- (void)loadMoreComments{
    CommentFrame * lastCommentsF = [self.commentsFrame lastObject];
    NSNumber *maxID;
    if (lastCommentsF) {
        maxID = [NSNumber numberWithLongLong:[lastCommentsF.comment.idstr longLongValue]];
    }
    
    [XYQApi getMoreCommentsWithAccessToken:[AccountTools account].access_token statusID:_statusFrame.status.idstr count:[NSString stringWithFormat:@"%d",20] maxID:maxID type:@"GET" success:^(id json) {
        NSArray * comments = json[@"comments"];
        
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newCom = [Comment objectArrayWithKeyValuesArray:comments];
        
        
        // 将status数组转换为frame数组

        for (Comment * comment in newCom) {
            CommentFrame * commentFrame = [[CommentFrame alloc]init];
            commentFrame.comment = comment;
            [self.commentsFrame addObject:commentFrame];
        }
        // 刷新表格
        [self.tableView reloadData];
        
        [self.tableView footerEndRefreshing];
        
        [MBProgressHUD hideHUD];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
        
        cell.linkDelegate = self;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        StatusFrame * statusframe = self.statusFrame;
        return statusframe.statusHeight - 33;
    }
    else {
        CommentFrame * frame = self.commentsFrame[indexPath.row];
        return frame.commentHeight;
    }
}




- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 33;
    }else
    {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        StatusFrame * statusframe = self.statusFrame;

        UIButton * btn1 = [self setupWithTitle:[NSString stringWithFormat:@"转发 %d",statusframe.status.reposts_count] btnX:0 backColor:[UIColor whiteColor] titleColor:[UIColor grayColor]];
        
        UIButton * btn2 = [self setupWithTitle:[NSString stringWithFormat:@"评论 %d",statusframe.status.comments_count] btnX:KScreen_W/4 + 1  backColor:[UIColor whiteColor] titleColor:[UIColor blackColor]];
        
        UIButton * btn3 = [self setupWithTitle:@"" btnX:KScreen_W/4 * 2 backColor:[UIColor whiteColor] titleColor:[UIColor grayColor]];
        UIButton * btn4 = [self setupWithTitle:[NSString stringWithFormat:@"赞 %d",statusframe.status.attitudes_count] btnX:KScreen_W/4 * 3 backColor:[UIColor whiteColor] titleColor:[UIColor grayColor]];
   
        UIView * header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreen_W, 35)];
        header.backgroundColor = color(211, 211, 211);
        
        UIView * sepLine = [[UIView alloc]initWithFrame:CGRectMake(0, 33, KScreen_W, 2)];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return;
    }
    UIActionSheet * sheet;
    CommentFrame * commentFrame = [[CommentFrame alloc]init];
    commentFrame = self.commentsFrame[indexPath.row];
    self.idstr =  commentFrame.comment.idstr;
    self.indexPath = indexPath;
    Account * account = [AccountTools account];
    NSString * str = account.name;
    NSString * str2 = commentFrame.comment.user.name;
    if ([str isEqualToString:str2]) {
        sheet = [[UIActionSheet alloc] initWithTitle:nil
                                            delegate:self
                                   cancelButtonTitle:@"Cancel"
                              destructiveButtonTitle: @"删除"
                                   otherButtonTitles:@"回复", nil];
        sheet.tag = 1000;
    }
    else
    {
        sheet = [[UIActionSheet alloc] initWithTitle:nil
                                            delegate:self
                                   cancelButtonTitle:@"Cancel"
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@"回复", nil];
        sheet.tag = 1001;
    }
    // Show the sheet
    [sheet showInView:self.view];
}




- (UIButton *)setupWithTitle:(NSString *)title btnX:(CGFloat)btnX backColor:(UIColor *)color titleColor:(UIColor *)titleColor{
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(btnX, 0, KScreen_W/4, 33)];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btn.backgroundColor = color;
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    
    return btn;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 44;
    }
    return 0;
}


#pragma mark - 工具栏点击事件代理
- (void)commentToolBar:(CommentToolBar *)toolBar DidClickButton:(NSUInteger)index{
    switch (index) {
        case 0: // 转发
        {
            RetweetViewController *ret = [[RetweetViewController alloc]init];
            ret.statusID = self.statusFrame.status.idstr;
            ret.statusFrame = self.statusFrame;
            NavigationController * nav = [[NavigationController alloc]initWithRootViewController:ret];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
            
        }
            break;
        case 1: // 评论
        {
            CommentViewController * comment = [[CommentViewController alloc]init];
            comment.statusID = self.statusFrame.status.idstr;
            NavigationController * nav = [[NavigationController alloc]initWithRootViewController:comment];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
            break;
            
            
        default:
            break;
    }
}

#pragma mark - statusCellLinkDelegate
/**  点击了链接 */
- (void)didClickStatusCellLinkTypeURL:(NSString *)URL{
    StatusLinkViewController * linkVC = [[StatusLinkViewController alloc]init];
    linkVC.URL = URL;
    [self.navigationController pushViewController:linkVC animated:YES];
}
/**  点击了电话 */
- (void)didClickStatusCellLinkTypePhoneNumber:(NSString *)PhoneNumber{
    XYQLog(@"%@",PhoneNumber);
}
/**  点击了邮箱 */
- (void)didClickStatusCellLinkTypeEmail:(NSString *)Email{
    XYQLog(@"%@",Email);
}
/**  点击了用户 */
- (void)didClickStatusCellLinkTypeAt:(NSString *)At{
    UserDetialViewController * user = [[UserDetialViewController alloc]init];
    user.userName = [At substringFromIndex:1];
    [self.navigationController pushViewController:user animated:YES];
}
/**  点击了话题 */
- (void)didClickStatusCellLinkTypePoundSign:(NSString *)PoundSign{
    XYQLog(@"%@",PoundSign);
}

#pragma mark - CommentCellLinkDelegate
/**  点击了链接 */
- (void)didClickCommentCellLinkTypeURL:(NSString *)URL{
    StatusLinkViewController * linkVC = [[StatusLinkViewController alloc]init];
    linkVC.URL = URL;
    [self.navigationController pushViewController:linkVC animated:YES];
}
/**  点击了电话 */
- (void)didClickCommentCellLinkTypePhoneNumber:(NSString *)PhoneNumber{
    XYQLog(@"%@",PhoneNumber);
}
/**  点击了邮箱 */
- (void)didClickCommentCellLinkTypeEmail:(NSString *)Email{
    XYQLog(@"%@",Email);
}
/**  点击了用户 */
- (void)didClickCommentCellLinkTypeAt:(NSString *)At{
    UserDetialViewController * user = [[UserDetialViewController alloc]init];
    user.userName = [At substringFromIndex:1];
    [self.navigationController pushViewController:user animated:YES];
}
/**  点击了话题 */
- (void)didClickCommentCellLinkTypePoundSign:(NSString *)PoundSign{
    XYQLog(@"%@",PoundSign);
}


#pragma mark  - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1000) {
        switch (buttonIndex) {
            case 0:
                [self destoryCommentWithIdStr:self.idstr];
                break;
            case 1:
            {
                RestoreCommentViewController * vc = [[RestoreCommentViewController alloc]init];
                vc.idstr = self.idstr;
                vc.statusID = self.statusFrame.status.idstr;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }
    if(actionSheet.tag == 1001)
    switch (buttonIndex) {
        case 0:
        {
            RestoreCommentViewController * vc = [[RestoreCommentViewController alloc]init];
            vc.idstr = self.idstr;
            vc.statusID = self.statusFrame.status.idstr;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)destoryCommentWithIdStr:(NSString *)idstr{
    [XYQApi destoryCommentWithAccessToken:[AccountTools account].access_token commentID:idstr type:@"POST" success:^(id json) {
        [MBProgressHUD showSuccess:@"删除评论成功"];
        [self.commentsFrame removeObjectAtIndex:self.indexPath.row];
        [self.tableView reloadData];
    }];
}


@end
