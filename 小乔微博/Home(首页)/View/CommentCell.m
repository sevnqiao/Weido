//
//  StatusesCell.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/4.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "CommentCell.h"
#import "CommentFrame.h"
#import "UIImageView+WebCache.h"
#import "Status.h"
#import "User.h"
#import "Comment.h"
#import "IconView.h"

@interface CommentCell()

@property (nonatomic,weak) UIView * originaView;  // 原创微博整体
@property (nonatomic,weak) IconView * iconView;  // 头像

@property (nonatomic,weak) UIImageView * vipView;  // vip
@property (nonatomic,weak) UILabel * nameLabel;  // 昵称
@property (nonatomic,weak) UILabel * timeLabel; // 时间
@property (nonatomic,weak) UILabel * contentLabel; // 内容


@end


@implementation CommentCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString * ID = @"commentCell";
    CommentCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    
    return cell;
}

/**
 *  设置frame
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //        self.selectedBackgroundView.backgroundColor = [UIColor redColor];
        
        [self setupOriginal];

    }
    return self;
}
/**
 *  初始化
 */
- (void)setupOriginal
{
    /** 原创微博的整体 */
    UIView *originalView = [[UIView alloc] init];
    originalView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:originalView];
    self.originaView = originalView;
    
    /** 头像 */
    IconView *iconView = [[IconView alloc] init];
    [originalView addSubview:iconView];
    self.iconView = iconView;
    
    /** 会员图标 */
    UIImageView *vipView = [[UIImageView alloc] init];
    vipView.contentMode = UIViewContentModeCenter;
    [originalView addSubview:vipView];
    self.vipView = vipView;

    
    /** 昵称 */
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:13];
    [originalView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    /** 时间 */
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.textColor = [UIColor orangeColor];
    [originalView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    

    
    /** 正文 */
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:13];
    contentLabel.numberOfLines = 0;
    [originalView addSubview:contentLabel];
    self.contentLabel = contentLabel;
}


/**
 *  设置内容
 *
 *  @param statusFrame <#statusFrame description#>
 */
- (void)setCommentFrame:(CommentFrame *)commentFrame
{
    _commentFrame = commentFrame;
    Comment * comment = commentFrame.comment;
    User * user = comment.user;
    
    
    /** 原创微博的整体 */
    self.originaView.frame = commentFrame.originaViewF;
    
    /** 头像 */
    self.iconView.frame = commentFrame.iconViewF;
    self.iconView.user = user;
    
    /** 昵称 */
    self.nameLabel.text = user.name;
    self.nameLabel.frame = commentFrame.nameLabelF;
    
    
    /** vip */
    if (user.isVip) {
        self.vipView.hidden = NO;
        self.vipView.frame = commentFrame.vipViewF;
        self.vipView.image = [UIImage imageNamed:[NSString stringWithFormat:@"common_icon_membership_level%d",user.mbrank]];
    }
    else
    {
        self.vipView.hidden = YES;
    }
    

    /** 时间 */
    self.timeLabel.frame = commentFrame.timeLabelF;
    self.timeLabel.text = comment.created_at;
    

    
    /** 正文内容 */
    self.contentLabel.frame = commentFrame.contentLabelF;
    self.contentLabel.text = comment.text;
    
    //------------------------------------------------------------------------------------------------------------//
    

}


@end
