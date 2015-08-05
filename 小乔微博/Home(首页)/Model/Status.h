//
//  Status.h
//  小乔微博
//
//  Created by 熊云桥 on 15/6/4.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;

@interface Status : NSObject

//        idstr 	string 	字符串型的微博ID
//        text 	string 	微博信息内容
//        user 	object 	微博作者的用户信息字段 详细

/**
 *  idstr 	string 	字符串型的微博ID
 */
@property (nonatomic , copy) NSString * idstr;

/**
 *  text 	string 	微博信息内容
 */
@property (nonatomic , copy) NSString * text;
/**
 *  user 	object 	微博作者的用户信息字段 详细
 */
@property (nonatomic , strong) User * user;
/**
 *  微博创建时间
 */
@property (nonatomic , copy) NSString * created_at;
/**
 *  微博来源
 */
@property (nonatomic , copy) NSString * source;

/**
 *  微博配图地址,多图时返回多图链接,无图返回空
 */
@property (nonatomic , strong)NSArray * pic_urls;

@property (nonatomic , copy) NSString * bmiddle_pic;

@property (nonatomic , strong) Status * retweeted_status;

@property (nonatomic , assign) int reposts_count;
@property (nonatomic , assign) int comments_count;
@property (nonatomic , assign) int attitudes_count;


@end
