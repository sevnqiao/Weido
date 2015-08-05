//
//  Product.h
//  Lottery
//
//  Created by 熊云桥 on 15/5/20.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic , copy) NSString * title;
@property (nonatomic , copy) NSString * ID;
@property (nonatomic , copy) NSString * url;
@property (nonatomic , copy) NSString * icon;
@property (nonatomic , copy) NSString * customUrl;


+ (instancetype)productWithDict:(NSDictionary *)dict;

@end
