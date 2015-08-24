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
#import "MLEmojiLabel.h"

@interface CommentCell()<MLEmojiLabelDelegate>

@property (nonatomic,strong) UIView * originaView;  // 原创微博整体
@property (nonatomic,strong) IconView * iconView;  // 头像

@property (nonatomic,strong) UIImageView * vipView;  // vip
@property (nonatomic,strong) UILabel * nameLabel;  // 昵称
@property (nonatomic,strong) UILabel * timeLabel; // 时间
@property (nonatomic,strong) MLEmojiLabel * contentLabel; // 内容


@end


@implementation CommentCell


//这个是通常的用法
- (MLEmojiLabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [MLEmojiLabel new];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:13.0f];
        _contentLabel.delegate = self;
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.isNeedAtAndPoundSign = YES;
        _contentLabel.disableEmoji = NO;
        _contentLabel.lineSpacing = 0.0f;
        _contentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
        
        //下面是自定义表情正则和图像plist的例子
        _contentLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        _contentLabel.customEmojiPlistName = @"expressionImage_custom";
    }
    return _contentLabel;
}

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
    self.contentLabel.emojiLabeldelegate = self;
    [originalView addSubview:self.contentLabel];

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


#pragma mark - delegate
- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    switch(type){
        case MLEmojiLabelLinkTypeURL:
            if ([self.linkDelegate respondsToSelector:@selector(didClickCommentCellLinkTypeURL:)]) {
                [self.linkDelegate didClickCommentCellLinkTypeURL:link];
            }
            break;
        case MLEmojiLabelLinkTypePhoneNumber:
            if ([self.linkDelegate respondsToSelector:@selector(didClickCommentCellLinkTypePhoneNumber:)]) {
                [self.linkDelegate didClickCommentCellLinkTypePhoneNumber:link];
            }
            break;
        case MLEmojiLabelLinkTypeEmail:
            if ([self.linkDelegate respondsToSelector:@selector(didClickCommentCellLinkTypeEmail:)]) {
                [self.linkDelegate didClickCommentCellLinkTypeEmail:link];
            }
            break;
        case MLEmojiLabelLinkTypeAt:
            if ([self.linkDelegate respondsToSelector:@selector(didClickCommentCellLinkTypeAt:)]) {
                [self.linkDelegate didClickCommentCellLinkTypeAt:link];
            }
            break;
        case MLEmojiLabelLinkTypePoundSign:
            if ([self.linkDelegate respondsToSelector:@selector(didClickCommentCellLinkTypePoundSign:)]) {
                [self.linkDelegate didClickCommentCellLinkTypePoundSign:link];
            }
            break;
        default:
            break;
    }
    
}

@end
