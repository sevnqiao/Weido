//
//  ComposeToolBar.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/12.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "CommentToolBar.h"

@interface CommentToolBar ()
@property(nonatomic , weak)UIButton * retweet;
@property(nonatomic , weak)UIButton * comment;
@property(nonatomic , weak)UIButton * unlike;

@end

@implementation CommentToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        
        
        self.retweet = [self setupBtnWithTitle:@"转发" Image:@"timeline_icon_comment"];
        self.comment = [self setupBtnWithTitle:@"评论" Image:@"timeline_icon_retweet"];
        self.unlike = [self setupBtnWithTitle:@"赞" Image:@"timeline_icon_unlike"];
        
        
    }
    return self;
}


- (UIButton *)setupBtnWithTitle:(NSString *)title Image:(NSString *)image
{
    UIButton * btn = [[UIButton alloc]init];
    btn.contentMode = UIViewContentModeCenter;
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 2. 设置其他按钮的位置
    CGFloat btnW = self.width / 3;
    CGFloat btnIndex = 0;
    
    for (int i = 0; i< self.subviews.count; i++) {
        UIButton * btn = self.subviews[i];
        btn.x = btnIndex * btnW;
        btn.y = 0;
        btn.width = btnW;
        btn.height = 44;
        btnIndex ++;
    }
}

- (void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(commentToolBar:DidClickButton:)]) {
        [self.delegate commentToolBar:self DidClickButton:(NSUInteger)(btn.x+1)/btn.width];
    }
}



@end
