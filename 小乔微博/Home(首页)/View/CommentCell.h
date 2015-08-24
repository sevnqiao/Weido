//
//  StatusesCell.h
//  小乔微博
//
//  Created by 熊云桥 on 15/6/4.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentFrame;

@protocol CommentCellLinkDelegate <NSObject>
@optional
/**
 *  点击了链接
 */
- (void)didClickCommentCellLinkTypeURL:(NSString *)URL;
/**
 *  点击了电话
 */
- (void)didClickCommentCellLinkTypePhoneNumber:(NSString *)PhoneNumber;
/**
 *  点击了邮箱
 */
- (void)didClickCommentCellLinkTypeEmail:(NSString *)Email;
/**
 *  点击了用户
 */
- (void)didClickCommentCellLinkTypeAt:(NSString *)At;
/**
 *  点击了话题
 */
- (void)didClickCommentCellLinkTypePoundSign:(NSString *)PoundSign;
@end

@interface CommentCell : UITableViewCell
@property (nonatomic , strong) CommentFrame * commentFrame;
@property (nonatomic , assign) id<CommentCellLinkDelegate>linkDelegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
