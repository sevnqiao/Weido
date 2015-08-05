//
//  SettingArrowItem.m
//  Lottery
//
//  Created by 熊云桥 on 15/5/20.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "SettingArrowItem.h"

@implementation SettingArrowItem

+ (instancetype)itemWithIcon:(NSString *)icon withTitle:(NSString *)title destVcClass:(Class)destVcClass
{
    SettingArrowItem * item = [super itemWithIcon:icon withTitle:title];
    item.destVcClass = destVcClass;
    return item;
}

@end
