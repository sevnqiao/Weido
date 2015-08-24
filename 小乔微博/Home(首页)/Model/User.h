//
//  User.h
//  小乔微博
//
//  Created by 熊云桥 on 15/6/4.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Status;

typedef enum{
    UserVerifiedTypeNone = -1, // 没有认证
    UserVerifiedTypePerson = 0, // 没有认证
    UserVerifiedTypeOrgEnterprice = 2, // 没有认证
    UserVerifiedTypeOrgMedia = 3, // 没有认证
    UserVerifiedTypeWebsite = 5, // 没有认证
    UserVerifiedTypeDaren = 220, // 没有认证
}UserVerifiedType;


@interface User : NSObject
/**
 *  字符串型的用户UID
 */
@property (nonatomic , copy) NSString * idstr;
/**
 *  友好显示名称
 */
@property (nonatomic , copy) NSString * name;
/**
 *  用户头像地址（中图），50×50像素
 */
@property (nonatomic , copy) NSString * profile_image_url;

@property (nonatomic , assign) int verified_type;



/**
 *  会员类型  值大于2, 才代表是会员
 */
@property (nonatomic , assign) int mbtype;
/**
 *  会员等级
 */
@property (nonatomic , assign) int mbrank;
@property (nonatomic , assign , getter=isVip) BOOL vip;

@property(nonatomic,strong)Status *status;

@property(nonatomic,strong)NSString *following;

@end
