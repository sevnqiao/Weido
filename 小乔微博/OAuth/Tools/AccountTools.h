//
//  AccountTools.h
//  小乔微博
//
//  Created by 熊云桥 on 15/6/4.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Account;

@interface AccountTools : NSObject


+ (void)saveAccount:(Account *)account;

+ (Account *)account;
@end
