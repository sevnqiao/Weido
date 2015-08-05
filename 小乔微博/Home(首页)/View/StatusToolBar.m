//
//  StatusToolBar.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/7.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "StatusToolBar.h"
#import "Status.h"

@interface StatusToolBar()
@property(nonatomic , weak)UIButton * retweet;
@property(nonatomic , weak)UIButton * comment;
@property(nonatomic , weak)UIButton * unlike;
@end


@implementation StatusToolBar

- (void)setStatus:(Status *)status
{
    _status = status;
    
    [self setupBtnWithCount:status.reposts_count btn:self.retweet title:@"转发"];
    [self setupBtnWithCount:status.comments_count btn:self.comment title:@"评论"];
    [self setupBtnWithCount:status.attitudes_count btn:self.unlike title:@"赞"];
}

- (void)setupBtnWithCount:(int)count btn:(UIButton *)btn title:(NSString *)title
{
    if (count) {
        if (count < 10000) {
            title = [NSString stringWithFormat:@"%d",count ];
        } else {
            title = [NSString stringWithFormat:@"%.1f万",count/10000.0 ];
        }
    } else{
        [btn setTitle:title forState:UIControlStateNormal];
    }
    [btn setTitle:title forState:UIControlStateNormal];
}

+ (instancetype)toolBar
{
    return [[self alloc]init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.retweet = [self setupBtnWithTitle:@"转发" Image:@"timeline_icon_retweet"];
        self.comment = [self setupBtnWithTitle:@"评论" Image:@"timeline_icon_comment"];
        self.unlike = [self setupBtnWithTitle:@"赞" Image:@"timeline_icon_unlike"];
    }
    return self;
}

- (UIButton *)setupBtnWithTitle:(NSString *)title Image:(NSString *)image
{
    UIButton * btn = [[UIButton alloc]init];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.contentMode = UIViewContentModeCenter;
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self addSubview:btn];
    return btn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int count = (int)self.subviews.count;
    CGFloat btnW = [UIScreen mainScreen].bounds.size.width / count;
    for (int i = 0; i < count; i ++) {
        UIButton * btn = self.subviews[i];
        btn.y = 0;
        btn.width = btnW;
        btn.x = i * btnW;
        btn.height = self.height;
    }
}


- (void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(statusToolBar:DidClickButton:)]) {
        [self.delegate statusToolBar:self DidClickButton:(NSInteger)(btn.x + 1)/btn.width];
    }
}
@end
