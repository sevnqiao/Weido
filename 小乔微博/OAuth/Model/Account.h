//
//  Acount.h
//  小乔微博
//
//  Created by 熊云桥 on 15/6/4.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject <NSCoding>
/**
 *  access_token 	string 	用于调用access_token，接口获取授权后的access token。
 */
@property (nonatomic , copy) NSString * access_token;
/**
 *  expires_in 	string 	access_token的生命周期，单位是秒数。
 */
@property (nonatomic , copy) NSString * expires_in;
/**
 *  remind_in 	string 	access_token的生命周期（该参数即将废弃，开发者请使用expires_in）。
 */
@property (nonatomic , copy) NSString * remind_in;
/**
 *  uid 	string 	当前授权用户的UID。
 */
@property (nonatomic , copy) NSString * uid;
/**
 *  用来保存access_token创建的时间
 */
@property (nonatomic , strong) NSDate * create_time;


/**
 *  用户昵称
 */
@property (nonatomic , copy) NSString * name;


+ (instancetype)accountWithDict:(NSDictionary *)dict;



@end
