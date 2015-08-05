//
//  Help.h
//  Lottery
//
//  Created by 熊云桥 on 15/5/21.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Help : NSObject
@property (nonatomic , copy) NSString * title;
@property (nonatomic , copy) NSString * ID;
@property (nonatomic , copy) NSString * html;

+ (instancetype)htmlWithDict:(NSDictionary *)dict;

@end
