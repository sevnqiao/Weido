//
//  Product.m
//  Lottery
//
//  Created by 熊云桥 on 15/5/20.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "Product.h"

@implementation Product

+ (instancetype)productWithDict:(NSDictionary *)dict
{
    
    Product * product = [[Product alloc]init];
    
    product.title = dict[@"title"];
    product.icon = dict[@"icon"];
    product.url = dict[@"url"];
    product.customUrl = dict[@"customUrl"];
    product.ID = dict[@"id"];
    
    
    return product;
    
}

@end
