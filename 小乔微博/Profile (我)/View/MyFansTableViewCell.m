//
//  MyFansTableViewCell.m
//  小乔微博
//
//  Created by Sevn on 15/8/18.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#define kPadding 10.0

#import "MyFansTableViewCell.h"
#import "User.h"
#import "Status.h"
#import "UIImageView+WebCache.h"
#import "IconView.h"

@interface MyFansTableViewCell ()
@property(nonatomic,strong)UIView *view;
@property (nonatomic,weak) IconView * icon;  // 头像
@property(nonatomic,strong)UILabel *nameL;
@property(nonatomic,strong)UIImageView *vipView;
@property(nonatomic,strong)UILabel *lastStatusL;
@property(nonatomic,strong)UILabel *sourceL;
@property(nonatomic,strong)UIButton *addBtn;
@end

@implementation MyFansTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    UIView * view = [[UIView alloc]init];
    [self addSubview:view];
    self.view = view;
    
    IconView * icon = [[IconView alloc]init];
    icon.x = kPadding;
    icon.y = kPadding+5;
    icon.width = 40;
    icon.height = 40;
    [view addSubview:icon];
    self.icon = icon;
    
    UILabel * nameL = [[UILabel alloc]init];
    nameL.numberOfLines = 1;
    nameL.textAlignment = NSTextAlignmentLeft;
    nameL.font = [UIFont systemFontOfSize:13.0f];
    [view addSubview:nameL];
    self.nameL = nameL;
    
    /** 会员图标 */
    UIImageView *vipView = [[UIImageView alloc] init];
    vipView.contentMode = UIViewContentModeCenter;
    [view addSubview:vipView];
    self.vipView = vipView;
    
    UILabel * lastStatusL = [[UILabel alloc]init];
    lastStatusL.font = [UIFont systemFontOfSize:13.0f];
    lastStatusL.textAlignment = NSTextAlignmentLeft;
    [view addSubview:lastStatusL];
    self.lastStatusL = lastStatusL;
    
    UILabel * sourceL = [[UILabel alloc]init];
    sourceL.font = [UIFont systemFontOfSize:13.0f];
    sourceL.textAlignment = NSTextAlignmentLeft;
    [view addSubview:sourceL];
    self.sourceL = sourceL;
    
    UIButton * addBtn = [[UIButton alloc]init];
    addBtn.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:addBtn];
    self.addBtn = addBtn;
    
}

- (void)setUser:(User *)user
{
    _user = user;
    Status * status = user.status;
    
    /** 头像 */
    self.icon.layer.cornerRadius = self.icon.width/2;
    self.icon.user = user;
    
    /** 昵称 */
    self.nameL.text = user.name;
    CGFloat nameX = CGRectGetMaxX(self.icon.frame) + kPadding;
    CGFloat nameY = kPadding;
    CGSize nameSize = [user.name sizeWithFont:[UIFont systemFontOfSize:15]];
    self.nameL.frame = (CGRect){{nameX, nameY}, nameSize};
    
    /** vip */
    if (user.isVip) {
        self.vipView.hidden = NO;
        self.vipView.frame = CGRectMake(CGRectGetMaxX(self.nameL.frame)+ kPadding, kPadding, 14, 14);
        self.vipView.image = [UIImage imageNamed:[NSString stringWithFormat:@"common_icon_membership_level%d",user.mbrank]];
    }
    else
    {
        self.vipView.hidden = YES;
    }
    
    if ([user.following isEqualToString:@"0"]) {
        [self.addBtn setImage:[UIImage imageNamed:@"card_icon_addattention"] forState:UIControlStateNormal];
        [self.addBtn addTarget:self action:@selector(addAttentionClick) forControlEvents:UIControlEventTouchUpInside];
    }
    if ([user.following isEqualToString:@"1"]) {
        [self.addBtn setImage:[UIImage imageNamed:@"card_icon_arrow"] forState:UIControlStateNormal];
        [self.addBtn addTarget:self action:@selector(cancelAttentionClick) forControlEvents:UIControlEventTouchUpInside];
    }
    self.addBtn.titleLabel.text = user.idstr;
    [self.addBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [self.addBtn setBackgroundImage:[UIImage imageNamed:@"common_button_sort_dotted"] forState:UIControlStateNormal];
    self.addBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - kPadding - 40, 15, 40, 24);
    
    self.lastStatusL.frame = CGRectMake(CGRectGetMaxX(_icon.frame) + kPadding, CGRectGetMaxY(self.nameL.frame)+2, [UIScreen mainScreen].bounds.size.width - _icon.width - 4 * kPadding - self.addBtn.width, 15);
    self.lastStatusL.text = status.text;
    
    self.sourceL.frame = CGRectMake(CGRectGetMaxX(_icon.frame) + kPadding, 70 - 15 - kPadding, [UIScreen mainScreen].bounds.size.width - _icon.width - 4 * kPadding - self.addBtn.width, 15);
    self.sourceL.text = @"123";
    
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CGRectGetMaxY(self.icon.frame) + kPadding);
    self.cellHeight =  CGRectGetHeight(self.view.frame);
}

- (void)addAttentionClick
{
    NSString * idstr = self.addBtn.titleLabel.text;
    if ([self.delegate respondsToSelector:@selector(addAttentionWithIdStr:)]) {
        [self.delegate addAttentionWithIdStr:idstr];
    }
}

- (void)cancelAttentionClick
{
    NSString * idstr = self.addBtn.titleLabel.text;
    if ([self.delegate respondsToSelector:@selector(cancelAttentionWithIdStr:)]) {
        [self.delegate cancelAttentionWithIdStr:idstr];
    }
    
}


@end
