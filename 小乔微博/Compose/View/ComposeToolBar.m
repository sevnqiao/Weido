//
//  ComposeToolBar.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/12.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "ComposeToolBar.h"

@implementation ComposeToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        
        // 初始化按钮
        [self setupBtn:@"compose_camerabutton_background" highImage:@"compose_camerabutton_background_highlighted"];
        [self setupBtn:@"compose_toolbar_picture"
             highImage:@"compose_toolbar_picture_highlighted"];
        [self setupBtn:@"compose_mentionbutton_background" highImage:@"compose_mentionbutton_background_highlighted"];
        [self setupBtn:@"compose_trendbutton_background" highImage:@"compose_trendbutton_background_highlighted"];
        [self setupBtn:@"compose_emoticonbutton_background" highImage:@"compose_emoticonbutton_background_highlighted"];
    }
    return self;
}


- (void)setupBtn:(NSString *)image highImage:(NSString *)highImage
{
    UIButton * btn = [[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 2. 设置其他按钮的位置
    CGFloat btnW = self.width / 5;
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
    if ([self.delegate respondsToSelector:@selector(composeToolBar:DidClickButton:)]) {
        [self.delegate composeToolBar:self DidClickButton:(NSUInteger)btn.x/btn.width];
    }
}



@end
