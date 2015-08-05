//
//  TabBar.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/3.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "TabBar.h"

@interface TabBar ()

@property(nonatomic, weak)UIButton * plusBtn;

@end

@implementation TabBar


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 3. 添加一个按钮到tabBar中间位置
        UIButton * plusBtn = [[UIButton alloc]init];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        plusBtn.size = plusBtn.currentBackgroundImage.size;
        [plusBtn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;
    }
    return self;
}

- (void)plusClick
{
    // 通知代理
    if ([self.delegatePlus respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.delegatePlus tabBarDidClickPlusButton:self];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1. 设置＋号按钮的位置
    self.plusBtn.centerX = self.width * 0.5;
    self.plusBtn.centerY = self.height * 0.5;

    // 2. 设置其他按钮的位置
    CGFloat tabBarBtnW = self.width / 5;
    CGFloat tabBarBtnIndex = 0;
    
    for (UIView * child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            child.x = tabBarBtnIndex * tabBarBtnW;
            tabBarBtnIndex ++;
            if (tabBarBtnIndex == 2) {
                tabBarBtnIndex ++;
            }
        }
    }
    
    
//    
//    
//    int count = self.subviews.count;
//    for (int i = 0; i < count; i++) {
//        UIView * child = self.subviews[i];
//        Class class = NSClassFromString(@"UITabBarButton");
//        if ([child isKindOfClass:class]) {
//            child.x = tabBarBtnIndex * tabBarBtnW;
//            tabBarBtnIndex ++;
//            if (tabBarBtnIndex == 2) {
//                tabBarBtnIndex ++;
//            }
//        }
//    }
}

@end
