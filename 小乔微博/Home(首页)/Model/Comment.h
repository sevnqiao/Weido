//
//  Status.h
//  小乔微博
//
//  Created by 熊云桥 on 15/6/4.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User,Status;

@interface Comment : NSObject


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

@property (nonatomic , copy) NSString * idstr;

@property (nonatomic , strong) Status *status;

@property(nonatomic,copy)NSString * source;

@property(nonatomic,strong)Comment * reply_comment;
@end
