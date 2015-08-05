//
//  StatusTool.h
//  小乔微博
//
//  Created by 熊云桥 on 15/6/10.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusTool : NSObject

/**
 *  根据请求参数从沙盒中加载缓存的微博数据
 */
+ (NSArray *)statusesWithParams:(NSDictionary *)params;
/**
 *  存储微博数据到沙河中
 *
 *  @param statuses 需要存储的数据
 */
+ (void)saveStatuses:(NSArray *)statuses;

@end
