//
//  SaveTool.m
//  Lottery
//
//  Created by 熊云桥 on 15/5/20.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "SaveTool.h"

@implementation SaveTool


+ (void) setObject:(id)value forKey:(NSString *)defaultName
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)objectForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}

@end
