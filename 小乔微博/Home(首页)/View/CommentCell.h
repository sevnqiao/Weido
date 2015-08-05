//
//  StatusesCell.h
//  小乔微博
//
//  Created by 熊云桥 on 15/6/4.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentFrame;

@interface CommentCell : UITableViewCell
@property (nonatomic , strong) CommentFrame * commentFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
