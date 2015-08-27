//
//  StatusesCell.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/4.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "StatusCell.h"
#import "StatusFrame.h"
#import "UIImageView+WebCache.h"
#import "Status.h"
#import "User.h"
#import "Photo.h"
#import "StatusToolBar.h"
#import "StatusPhotosView.h"
#import "IconView.h"
#import "MLEmojiLabel.h"


@interface StatusCell()<StatusToolBarDelegate,MLEmojiLabelDelegate,StatusesPhotosViewDelegate>

@property (nonatomic,weak) UIView * originaView;  // 原创微博整体
@property (nonatomic,weak) IconView * iconView;  // 头像
@property (nonatomic,weak) StatusPhotosView * photosView;  // 配图
@property (nonatomic,weak) UIImageView * vipView;  // vip
@property (nonatomic,weak) UILabel * nameLabel;  // 昵称
@property (nonatomic,weak) UILabel * timeLabel; // 时间
@property (nonatomic,weak) UILabel * sourceLabel; // 微博来源
@property (nonatomic,strong) MLEmojiLabel * contentLabel; // 微博内容


/**
 *  转发微博
 */
@property (nonatomic, weak)UIView *retweetView;
@property (nonatomic,strong) MLEmojiLabel * retweetContentLabel; // 微博内容
@property (nonatomic,weak) StatusPhotosView * retweetPhotosView;  // 配图


@end


@implementation StatusCell

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

- (MLEmojiLabel *)retweetContentLabel
{
    if (!_retweetContentLabel) {
        _retweetContentLabel = [MLEmojiLabel new];
        _retweetContentLabel.numberOfLines = 0;
        _retweetContentLabel.font = [UIFont systemFontOfSize:13.0f];
        _retweetContentLabel.delegate = self;
        _retweetContentLabel.backgroundColor = [UIColor clearColor];
        _retweetContentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _retweetContentLabel.textColor = [UIColor blackColor];
        _retweetContentLabel.isNeedAtAndPoundSign = YES;
        _retweetContentLabel.disableEmoji = NO;
        _retweetContentLabel.lineSpacing = 0.0f;
        _retweetContentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
        _retweetContentLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        _retweetContentLabel.customEmojiPlistName = @"expressionImage_custom";
    }
    return _retweetContentLabel;
}





+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString * ID = @"statusCell";
    StatusCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[StatusCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    
    return cell;
}

/**
 *  设置frame
 *
 *  @param style           <#style description#>
 *  @param reuseIdentifier <#reuseIdentifier description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.selectedBackgroundView.backgroundColor = [UIColor redColor];
        
        [self setupOriginal];
        
        [self setupRetweet];
        
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
    [self.contentView addSubview:toolBar];
    self.toolBar = toolBar;
    
}

- (void)removeToolBar
{
    [self.toolBar removeFromSuperview];
}

/**
 *  初始化转发微博
 */
- (void)setupRetweet
{
    /** 转发微博的整体 */
    UIView *retweetView = [[UIView alloc] init];
    retweetView.backgroundColor = color(247, 247, 247);
    [self.contentView addSubview:retweetView];
    self.retweetView = retweetView;
    
    /** 转发微博的配图 */
    StatusPhotosView *retweetPhotosView = [[StatusPhotosView alloc] init];
    retweetPhotosView.delegate = self;
    
    [retweetView addSubview:retweetPhotosView];
    self.retweetPhotosView = retweetPhotosView;
    
    
    
    /** 转发微博的正文 */
    self.retweetContentLabel.emojiLabeldelegate = self;
    self.retweetContentLabel.font = [UIFont systemFontOfSize:13];
    self.retweetContentLabel.numberOfLines = 0;
    self.retweetContentLabel.backgroundColor = color(247, 247, 247);
    [retweetView addSubview:self.retweetContentLabel];
}


/**
 *  初始化原创微博
 */
- (void)setupOriginal
{
    /** 原创微博的整体 */
    UIView *originalView = [[UIView alloc] init];
    originalView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:originalView];
    self.originaView = originalView;
    
    /** 头像 */
    IconView *iconView = [[IconView alloc] init];
    iconView.layer.cornerRadius = iconView.width/2;
    [originalView addSubview:iconView];
    self.iconView = iconView;
    
    /** 会员图标 */
    UIImageView *vipView = [[UIImageView alloc] init];
    vipView.contentMode = UIViewContentModeCenter;
    [originalView addSubview:vipView];
    self.vipView = vipView;
    
    /** 配图 */
    StatusPhotosView *photosView = [[StatusPhotosView alloc] init];
    [originalView addSubview:photosView];
    photosView.delegate = self;
    self.photosView = photosView;
    
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
    
    /** 来源 */
    UILabel *sourceLabel = [[UILabel alloc] init];
    sourceLabel.font = [UIFont systemFontOfSize:13];
    sourceLabel.textColor = [UIColor orangeColor];
    [originalView addSubview:sourceLabel];
    self.sourceLabel = sourceLabel;
    
    /** 正文 */
    self.contentLabel.emojiLabeldelegate = self;
    [originalView addSubview:self.contentLabel];
}


/**
 *  设置内容
 *
 *  @param statusFrame <#statusFrame description#>
 */
- (void)setStatusFrame:(StatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    Status * status = statusFrame.status;
    User * user = status.user;
    
    
    /** 原创微博的整体 */
    self.originaView.frame = statusFrame.originaViewF;
    
    /** 头像 */
    self.iconView.frame = statusFrame.iconViewF;
    self.iconView.layer.cornerRadius = self.iconView.width/2;
    self.iconView.user = user;
    
    /** 昵称 */
    self.nameLabel.text = user.name;
    self.nameLabel.frame = statusFrame.nameLabelF;
    
    /** vip */
    if (user.isVip) {
        self.vipView.hidden = NO;
        self.vipView.frame = statusFrame.vipViewF;
        self.vipView.image = [UIImage imageNamed:[NSString stringWithFormat:@"common_icon_membership_level%d",user.mbrank]];
    }
    else
    {
        self.vipView.hidden = YES;
    }
    
    
    /** 配图 */
    if (status.pic_urls.count) {
        self.photosView.frame = statusFrame.photosViewF;
        
        self.photosView.photos = status.pic_urls;
        
        
        self.photosView.hidden = NO;
    }
    else
    {
        self.photosView.hidden = YES;
    }
    /** 时间 */
    self.timeLabel.frame = statusFrame.timeLabelF;
    self.timeLabel.text = status.created_at;
    
    /** 来源 */
    self.sourceLabel.frame = statusFrame.sourceLabelF;
    self.sourceLabel.text = status.source;
    
    /** 正文内容 */
    self.contentLabel.frame = statusFrame.contentLabelF;
    self.contentLabel.text = status.text;
    
    //------------------------------------------------------------------------------------------------------------//
    
    /**
     *  被装法的微博
     */
    if (status.retweeted_status) {
        
        Status * retweeted_status = status.retweeted_status;
        User * retweeted_status_user =retweeted_status.user;
        
        
        self.retweetView.hidden = NO;
        
        /**  */
        self.retweetView.frame = statusFrame.retweetViewF;
        
        /** 正文内容 */
        self.retweetContentLabel.frame = statusFrame.retweetContentLabelF;
        NSString * retweetContent = [NSString stringWithFormat:@"@%@ : %@",retweeted_status_user.name,retweeted_status.text];
        
        self.retweetContentLabel.text = retweetContent;
        
        
        
        /** 配图 */
        if (retweeted_status.pic_urls.count) {
            self.retweetPhotosView.frame = statusFrame.retweetPhotosViewF;
            self.retweetPhotosView.photos = retweeted_status.pic_urls;
            self.retweetPhotosView.hidden = NO;
        }
        else
        {
            self.retweetPhotosView.hidden = YES;
        }
        
    }
    else
    {
        self.retweetView.hidden = YES;
    }
        /** 工具条 */
        self.toolBar.frame = statusFrame.toolBarF;
        self.toolBar.status = status;
}


#pragma mark - statusToolBarDelegate
- (void)statusToolBar:(StatusToolBar *)toolBar DidClickButton:(int)tag
{
    if ([self.delegate respondsToSelector:@selector(didClickCellCommentWithIndexPath: WithType:)]) {
        [self.delegate didClickCellCommentWithIndexPath:self.indexPath WithType:tag];
    }
}

#pragma mark - delegate
- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    switch(type){
        case MLEmojiLabelLinkTypeURL:
            if ([self.linkDelegate respondsToSelector:@selector(didClickStatusCellLinkTypeURL:)]) {
                        [self.linkDelegate didClickStatusCellLinkTypeURL:link];
                    }
            break;
        case MLEmojiLabelLinkTypePhoneNumber:
            if ([self.linkDelegate respondsToSelector:@selector(didClickStatusCellLinkTypePhoneNumber:)]) {
                [self.linkDelegate didClickStatusCellLinkTypePhoneNumber:link];
            }
            break;
        case MLEmojiLabelLinkTypeEmail:
            if ([self.linkDelegate respondsToSelector:@selector(didClickStatusCellLinkTypeEmail:)]) {
                [self.linkDelegate didClickStatusCellLinkTypeEmail:link];
            }
            break;
        case MLEmojiLabelLinkTypeAt:
            if ([self.linkDelegate respondsToSelector:@selector(didClickStatusCellLinkTypeAt:)]) {
                [self.linkDelegate didClickStatusCellLinkTypeAt:link];
            }
            break;
        case MLEmojiLabelLinkTypePoundSign:
            if ([self.linkDelegate respondsToSelector:@selector(didClickStatusCellLinkTypePoundSign:)]) {
                [self.linkDelegate didClickStatusCellLinkTypePoundSign:link];
            }
            break;
        default:
            break;
    }
    
}

- (void) tapImageViewsTappedWithObject:(int)index withPhotosArr:(NSArray *)photos WithImageView:(UIImageView *)imageView;
{
    if ([self.delegate respondsToSelector:@selector(didClickPhotoWithObjects:withPhotosArr:WithImageView:)]) {
        [self.delegate didClickPhotoWithObjects:index withPhotosArr:photos WithImageView:imageView];
    }
}
@end
