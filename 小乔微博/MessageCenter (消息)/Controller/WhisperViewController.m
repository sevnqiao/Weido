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
    
    [self loadNew];
    
    [self.tableView addHeaderWithTarget:self action:@selector(loadNew)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMore)];
}

- (void)loadNew
{
    [MBProgressHUD showMessage:@"正在加载中"];
    Comment * comment = [self.commentsArr firstObject];
    NSNumber *sinceID;
    if (comment) {
        sinceID = [NSNumber numberWithLongLong:[comment.status.idstr longLongValue]];
    }
    [XYQApi getNewMyCommentWithAccessToken:[AccountTools account].access_token sinceID:sinceID count:@(100) type:@"GET" success:^(id json) {
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
    }];
}

- (void)loadMore
{
    [MBProgressHUD showMessage:@"正在加载中"];
    Comment * lastComment = [self.commentsArr lastObject];
    NSNumber *maxID ;
    if (lastComment) {
        maxID = [NSNumber numberWithLongLong:[lastComment.status.idstr longLongValue]];
    }
    [XYQApi getMoreMyCommentWithAccessToken:[AccountTools account].access_token maxID:maxID count:@(100) type:@"GET" success:^(id json) {
        NSArray * arr = json[@"comments"];
        if (arr.count == 0) {
            [MBProgressHUD showError:@"新浪个2B , 不给数据了"];
        }
        for (NSDictionary * dict in arr) {
            Comment * comment = [Comment objectWithKeyValues:dict];
            [_commentsArr addObject:comment];
        }
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        [MBProgressHUD hideHUD];
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
    return cell.cellHeight;
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
