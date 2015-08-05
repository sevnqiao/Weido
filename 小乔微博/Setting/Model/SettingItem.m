//
//  SettingItem.m
//  Lottery
//
//  Created by 熊云桥 on 15/5/20.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "SettingItem.h"

@implementation SettingItem

+ (instancetype)itemWithIcon:(NSString *)icon withTitle:(NSString *)title
{
    SettingItem * item  = [[self alloc]init];
    
    item.icon = icon;
    item.title = title;
    
    return item;
}

@end
