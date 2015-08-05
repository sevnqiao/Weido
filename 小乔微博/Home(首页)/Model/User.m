//
//  User.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/4.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "User.h"

@implementation User

- (void)setMbtype:(int)mbtype
{
    _mbtype = mbtype;
    
    self.vip = mbtype > 2;
}

@end
