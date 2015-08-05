//
//  Help.m
//  Lottery
//
//  Created by 熊云桥 on 15/5/21.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "Help.h"

@implementation Help


+ (instancetype)htmlWithDict:(NSDictionary *)dict
{
    
    Help * help = [[Help alloc]init];
    
    help.title = dict[@"title"];
    help.html = dict[@"html"];
    help.ID = dict[@"id"];
    
    
    return help;
    
}

@end
