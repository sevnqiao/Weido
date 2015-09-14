//
//  WhisperCell.m
//  小乔微博
//
//  Created by Sevn on 15/8/20.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#define kPadding 10

#import "WhisperCell.h"
#import "IconView.h"
#import "MLEmojiLabel.h"
#import "Status.h"
#import "User.h"
#import "Comment.h"
#import "UIImageView+WebCache.h"
#import "StatusToolBar.h"
#import "Photo.h"

@interface WhisperCell ()<StatusToolBarDelegate,MLEmojiLabelDelegate>
@property (nonatomic,strong) UIView * originaView;  // 原创微博整体
@property (nonatomic,strong) IconView * iconView;  // 头像
@property (nonatomic,strong) UIImageView * vipView;  // vip
@property (nonatomic,strong) UILabel * nameLabel;  // 昵称
@property (nonatomic,strong) UILabel * timeLabel; // 时间
@property (nonatomic,strong) UILabel * sourceLabel; // 评论来源
@property (nonatomic,strong) MLEmojiLabel * contentLabel; // 评论内容
@property(nonatomic,strong)UIButton *replyBtn;// 回复按钮

/** 转发评论 */
@property(nonatomic,strong)MLEmojiLabel * reply_commentLabel;
@property(nonatomic,strong)UIView * reply_commentView;

/** 微博内容 */
@property(nonatomic,strong)UIView *statusView;
@property(nonatomic,strong)UIImageView *statusPhotoVoew;
@property(nonatomic,strong)UILabel *statusNameLabel;
@property(nonatomic,strong)UILabel *statusContentLabel;

/** 工具条 */
@property(nonatomic,strong)StatusToolBar *toolBar;

@property(nonatomic,strong)UIView * divideView;

@property(nonatomic,copy)NSString *commentIDstr;
@property(nonatomic,copy)NSString *statusIDstr;
@end

@implementation WhisperCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        [self setupToolBar];
    }
    return self;
}

/**
 *  初始化工具条
 */
- (void)setupToolBar
{
    StatusToolBar * toolBar = [[StatusToolBar alloc]init];
    toolBar.delegate = self;
    toolBar.backgroundColor = [UIColor whiteColor];
    [self addSubview:toolBar];
    self.toolBar = toolBar;
    
}

- (void)setupUI
{
    _originaView = [[UIView alloc]init];
    [self addSubview:_originaView];
    
    _iconView = [[IconView alloc]initWithFrame:CGRectMake(kPadding, kPadding, 35, 35)];
    [_originaView addSubview:_iconView];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font = [UIFont systemFontOfSize:13.0f];
    [_originaView addSubview:_nameLabel];
    
    _replyBtn = [[UIButton alloc]init];
    [_replyBtn setTitle:@"回复" forState:UIControlStateNormal];
    _replyBtn.layer.cornerRadius = 4;
    [_replyBtn addTarget:self action:@selector(reply) forControlEvents:UIControlEventTouchUpInside];
    [_replyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _replyBtn.backgroundColor = color(245, 245, 245);
    [_originaView addSubview:_replyBtn];
    
    _vipView = [[UIImageView alloc]init];
    _vipView.contentMode = UIViewContentModeScaleAspectFit;
    [_originaView addSubview:_vipView];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.font = [UIFont systemFontOfSize:11.0f];
    [_originaView addSubview:_timeLabel];
    
    _sourceLabel = [[UILabel alloc]init];
    _sourceLabel.textAlignment = NSTextAlignmentLeft;
    _sourceLabel.font = [UIFont systemFontOfSize:11.0f];
    [_originaView addSubview:_sourceLabel];
    
    
    _contentLabel = [[MLEmojiLabel alloc]init];
    _contentLabel.emojiLabeldelegate = self;
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = [UIFont systemFontOfSize:13.0f];
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _contentLabel.textColor = [UIColor blackColor];
    _contentLabel.isNeedAtAndPoundSign = YES;
    _contentLabel.disableEmoji = NO;
    _contentLabel.lineSpacing = 0.0f;
    _contentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    _contentLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    _contentLabel.customEmojiPlistName = @"expressionImage_custom";
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    [_originaView addSubview:_contentLabel];
    
    
    /** 转发评论 */
    _reply_commentView = [[UIView alloc]init];
    [_originaView addSubview:_reply_commentView];
    
    _reply_commentLabel = [[MLEmojiLabel alloc]init];
    _reply_commentLabel.emojiLabeldelegate = self;
    _reply_commentLabel.numberOfLines = 0;
    _reply_commentLabel.font = [UIFont systemFontOfSize:13.0f];
    _reply_commentLabel.backgroundColor = [UIColor clearColor];
    _reply_commentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _reply_commentLabel.textColor = [UIColor blackColor];
    _reply_commentLabel.isNeedAtAndPoundSign = YES;
    _reply_commentLabel.disableEmoji = NO;
    _reply_commentLabel.lineSpacing = 0.0f;
    _reply_commentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    _reply_commentLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    _reply_commentLabel.customEmojiPlistName = @"expressionImage_custom";
    _reply_commentLabel.textAlignment = NSTextAlignmentLeft;
    [_reply_commentView addSubview:_reply_commentLabel];
    
    _statusView = [[UIView alloc]init];
    [_reply_commentView addSubview:_statusView];
    
    /** 微博内容 */
    _statusPhotoVoew = [[UIImageView alloc]init];
    [_statusView addSubview:_statusPhotoVoew];
    
    _statusNameLabel = [[UILabel alloc]init];
    _statusNameLabel.textAlignment = NSTextAlignmentLeft;
    _statusNameLabel.font = [UIFont systemFontOfSize:13.0f];
    [_statusView addSubview:_statusNameLabel];
    
    _statusContentLabel = [[UILabel alloc]init];
    _statusContentLabel.textAlignment = NSTextAlignmentLeft;
    _statusContentLabel.numberOfLines = 2;
    _statusContentLabel.font = [UIFont systemFontOfSize:13.0f];
    [_statusView addSubview:_statusContentLabel];

    
    _divideView = [[UIView alloc]init];
    [self addSubview:_divideView];
    
}

- (void)setComment:(Comment *)comment
{
    _comment = comment;
    Status * status = comment.status;
    User * user = comment.user;
    _commentIDstr = comment.idstr;
    _statusIDstr = status.idstr;
    
    /** 头像 */
    _iconView.user = user;
    _iconView.layer.cornerRadius = self.iconView.width/2;
    
    /** 昵称 */
    _nameLabel.text = user.name;
    CGFloat nameX = CGRectGetMaxX(_iconView.frame) + kPadding;
    CGFloat nameY = kPadding;
    CGSize nameSize = [user.name sizeWithFont:[UIFont systemFontOfSize:15]];
    _nameLabel.frame = (CGRect){{nameX, nameY}, nameSize};
    
    _replyBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - kPadding - 55, kPadding, 55, 35);
    
    /** 会员图标 */
    CGFloat vipX = CGRectGetMaxX(_nameLabel.frame) + kPadding;
    CGFloat vipY = kPadding;
    CGFloat vipH = 14.0;
    CGFloat vipW = 14.0;
    _vipView.frame = CGRectMake(vipX, vipY, vipW, vipH);
    if (user.isVip) {
        _vipView.hidden = NO;
        _vipView.image = [UIImage imageNamed:[NSString stringWithFormat:@"common_icon_membership_level%d",user.mbrank]];
    }
    else
    {
        self.vipView.hidden = YES;
    }

    /** 时间 */
    self.timeLabel.text = comment.created_at;
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(_nameLabel.frame) + kPadding * 0.3;
    CGSize timeSize = [comment.created_at sizeWithFont:[UIFont systemFontOfSize:11.0f]];
    _timeLabel.frame = (CGRect){{timeX, timeY}, timeSize};
    
    /** 来源 */
    self.sourceLabel.text = comment.source;
    CGFloat sourceX = CGRectGetMaxX(_timeLabel.frame) + kPadding;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [comment.source sizeWithFont:[UIFont systemFontOfSize:11.0f]];
    _sourceLabel.frame = (CGRect){{sourceX, sourceY}, sourceSize};
    
    /** 正文 */
    self.contentLabel.text = comment.text;
    CGFloat contentX = kPadding;
    CGFloat contentY = CGRectGetMaxY(_iconView.frame) + kPadding;
    CGFloat maxW = [UIScreen mainScreen].bounds.size.width - 2 * kPadding;
    CGSize contentSize = [comment.text sizeWithFont:[UIFont systemFontOfSize:13.0f] maxW:maxW];
    _contentLabel.frame = CGRectMake(contentX, contentY, contentSize.width, contentSize.height);
    
    CGFloat statusViewY ;
    /** 转发评论 */
    if (comment.reply_comment) {
        _reply_commentView.backgroundColor = color(245, 245, 245);
        _statusView.backgroundColor = [UIColor whiteColor];
        
        
        Comment * reply_comment = comment.reply_comment;
        _reply_commentLabel.text = [NSString stringWithFormat:@"@%@ : %@",reply_comment.user.name,reply_comment.text];
        
        CGFloat reply_contentX = kPadding;
        CGFloat reply_contentY = kPadding;
        CGFloat reply_maxW = [UIScreen mainScreen].bounds.size.width - 2 * kPadding;
        CGSize reply_contentSize = [_reply_commentLabel.text sizeWithFont:[UIFont systemFontOfSize:13.0f] maxW:reply_maxW];
        _reply_commentLabel.frame = CGRectMake(reply_contentX, reply_contentY, reply_contentSize.width, reply_contentSize.height);
        
        statusViewY = CGRectGetMaxY(_reply_commentLabel.frame) + kPadding;
    }else{
        statusViewY = 0;
        _statusView.backgroundColor = color(245, 245, 245);
    }
    
    
   
    /** 照片 */
    _statusPhotoVoew.frame = CGRectMake(0, 0, 65, 65);
    if (status.pic_urls.count == 0) {
        NSString * str = status.user.profile_image_url;
        [_statusPhotoVoew sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    }
    else
    {
        Photo * photo = status.pic_urls[0];
        NSString * str = photo.thumbnail_pic;
        [_statusPhotoVoew sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    }
    /** 正文 */
    
    _statusNameLabel.text = @"@熊桥桥桥桥桥桥";
    _statusNameLabel.frame = CGRectMake(CGRectGetMaxX(_statusPhotoVoew.frame)+kPadding, kPadding, 200, 15);
    
    _statusContentLabel.text = status.text;
    _statusContentLabel.frame = CGRectMake(CGRectGetMaxX(_statusPhotoVoew.frame)+kPadding, CGRectGetMaxY(_statusNameLabel.frame), [UIScreen mainScreen].bounds.size.width - 4* kPadding - CGRectGetWidth(_statusPhotoVoew.frame), 40);
    
    _statusView.frame = CGRectMake(kPadding,statusViewY, [UIScreen mainScreen].bounds.size.width - 2*kPadding, 65);
    
    if (comment.reply_comment) {
        _reply_commentView.frame = CGRectMake(0, CGRectGetMaxY(_contentLabel.frame)+kPadding, [UIScreen mainScreen].bounds.size.width, 65 + CGRectGetMaxY(_reply_commentLabel.frame) + 2 * kPadding);
    }else
    {
        _reply_commentView.frame = CGRectMake(0, CGRectGetMaxY(_contentLabel.frame)+kPadding, [UIScreen mainScreen].bounds.size.width, 65);
    }
    
    
    _originaView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CGRectGetMaxY(_reply_commentView.frame)+kPadding);
    
    /** 工具条 */
    CGFloat toolBarX = 0;
    CGFloat toolBarY = CGRectGetMaxY(_originaView.frame);
    CGFloat toolBarW = [UIScreen mainScreen].bounds.size.width;
    CGFloat toolBarH = 30;
    _toolBar.frame = CGRectMake(toolBarX, toolBarY, toolBarW, toolBarH);
    _toolBar.status = status;
    
    _divideView.frame = CGRectMake(0, CGRectGetMaxY(_toolBar.frame), [UIScreen mainScreen].bounds.size.width, 2);
    _divideView.backgroundColor = [UIColor grayColor];
    
    _cellHeight = CGRectGetMaxY(_divideView.frame);
}


- (void)reply
{
    if ([self.delegate respondsToSelector:@selector(replyWithCommentID:CommentStatusID:)]) {
        [self.delegate replyWithCommentID:_commentIDstr CommentStatusID:_statusIDstr];
    }
}


@end
