//
//  WhisperViewController.m
//  小乔微博
//
//  Created by Sevn on 15/8/20.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "WhisperViewController.h"
#import "AccountTools.h"
#import "Account.h"
#import "Comment.h"
#import "WhisperCell.h"
#import "HttpTool.h"
#import "Status.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "RestoreCommentViewController.h"

@interface WhisperViewController ()<WhisperCellGelegate>
@property(nonatomic,copy)NSMutableArray *commentsArr;
@end

@implementation WhisperViewController

- (NSMutableArray *)commentsArr
{
    if (!_commentsArr) {
        _commentsArr = [NSMutableArray array];
    }
    return _commentsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"所有评论";
    
    [self sendRequest];
    
    [self.tableView addHeaderWithTarget:self action:@selector(sendRequest)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMore)];
}

- (void)sendRequest
{
    [MBProgressHUD showMessage:@"正在加载中"];
    Account * account = [AccountTools account];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    Comment * comment = [self.commentsArr firstObject];
    if (comment) {
        params[@"since_id"] = comment.status.idstr;
    }
    params[@"count"] = @(100);
    //https://api.weibo.com/2/comments/timeline.json
    //https://api.weibo.com/2/comments/mentions.json
    [HttpTool get:@"https://api.weibo.com/2/comments/timeline.json" params:params success:^(id json) {
        NSArray * arr = json[@"comments"];
        if (arr.count == 0) {
//            [MBProgressHUD showError:@"新浪个2B , 不给数据了"];
        }
        NSMutableArray * newArr = [NSMutableArray array];
        for (NSDictionary * dict in arr) {
            Comment * comment = [Comment objectWithKeyValues:dict];
            [newArr addObject:comment];
        }
        
        NSRange range = NSMakeRange(0, newArr.count);
        NSIndexSet * set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.commentsArr insertObjects:newArr atIndexes:set];
        
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        
    }];
}

- (void)loadMore
{
    [MBProgressHUD showMessage:@"正在加载中"];
    Account * account = [AccountTools account];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    Comment * lastComment = [self.commentsArr lastObject];
    if (lastComment) {
        params[@"max_id"] = lastComment.status.idstr;
    }
    params[@"count"] = @(100);
    //https://api.weibo.com/2/comments/timeline.json
    //https://api.weibo.com/2/comments/mentions.json
    [HttpTool get:@"https://api.weibo.com/2/comments/timeline.json" params:params success:^(id json) {
        NSArray * arr = json[@"comments"];
        if (arr.count == 0) {
            //            [MBProgressHUD showError:@"新浪个2B , 不给数据了"];
        }
        for (NSDictionary * dict in arr) {
            Comment * comment = [Comment objectWithKeyValues:dict];
            [_commentsArr addObject:comment];
        }
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentsArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"mentionsCell";
    WhisperCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[WhisperCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Comment * comment = self.commentsArr[indexPath.row];
    cell.comment = comment;
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WhisperCell * cell = [[WhisperCell alloc]init];
    cell.comment = self.commentsArr[indexPath.row];

    NSLog(@"cell.height -- %f",cell.cellHeight);
    return cell.cellHeight;
//    return 110;
}

/** 回复一条评论 */
- (void)replyWithCommentID:(NSString *)commentIDstr CommentStatusID:(NSString *)statusIDstr
{
    RestoreCommentViewController * vc = [[RestoreCommentViewController alloc]init];
    vc.idstr = commentIDstr;
    vc.statusID = statusIDstr;
    [self.navigationController pushViewController:vc animated:YES];
}



@end
