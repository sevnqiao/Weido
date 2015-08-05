//
//  AboutHeaderView.m
//  Lottery
//
//  Created by 熊云桥 on 15/5/21.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "AboutHeaderView.h"

@implementation AboutHeaderView


+ (instancetype)headerView
{
    return [[NSBundle mainBundle] loadNibNamed:@"AboutHeaderView" owner:nil options:nil][0];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
