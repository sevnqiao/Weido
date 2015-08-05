//
//  StatusesCell.h
//  小乔微博
//
//  Created by 熊云桥 on 15/6/4.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StatusFrame;
@class StatusCell;
@class StatusToolBar;
@protocol StatusCellDelegate <NSObject>
@optional
- (void)didClickCellCommentWithIndexPath:(int)indexPath;
- (void)didClickPhotoWithObjects:(id)sender;

@end

@protocol StatusCellLinkDelegate <NSObject>
@optional
/**
 *  点击了链接
 */
- (void)didClickStatusCellLinkTypeURL:(NSString *)URL;
/**
 *  点击了电话
 */
- (void)didClickStatusCellLinkTypePhoneNumber:(NSString *)PhoneNumber;
/**
 *  点击了邮箱
 */
- (void)didClickStatusCellLinkTypeEmail:(NSString *)Email;
/**
 *  点击了用户
 */
- (void)didClickStatusCellLinkTypeAt:(NSString *)At;
/**
 *  点击了话题
 */
- (void)didClickStatusCellLinkTypePoundSign:(NSString *)PoundSign;
@end


@interface StatusCell : UITableViewCell
@property (nonatomic , strong) StatusFrame * statusFrame;
@property (nonatomic , assign) int row;



@property (nonatomic , assign) id<StatusCellDelegate>delegate;
@property (nonatomic , assign) id<StatusCellLinkDelegate>linkDelegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


- (void)removeToolBar;
/**
 *  工具条
 */
@property (nonatomic, weak)StatusToolBar * toolBar;
@end
