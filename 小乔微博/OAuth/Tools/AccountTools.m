//
//  AccountTools.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/4.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//
/**
 *  处理与账号有关的所有操作 : 存储账号\取出账号\验证账号
 */

// 账号的存储路径
#define AccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"account.archiver"]

#import "AccountTools.h"
#import "Account.h"

@implementation AccountTools


/**
 *  存储账号信息
 */
+ (void)saveAccount:(Account *)account
{

    // 自定义对象的存储必须使用NSKeyedArchiver, 不能使用writeToFile
    [NSKeyedArchiver archiveRootObject:account toFile:AccountPath];
}

/**
 *  返回找好信息
 *
 *  @return 账号模型 (如果账号过期 , 则返回nil)
 */
+ (Account *)account;
{
    // 1. 加载模型
    Account * account = [NSKeyedUnarchiver unarchiveObjectWithFile:AccountPath];
    
    if (account == nil) {
        return nil;
    }
    // 2. 验证账号是否过期
    // 过期的秒数
    long long expires_in = [account.expires_in longLongValue];
    // 获得过期时间
    NSDate * expire = [account.create_time dateByAddingTimeInterval:expires_in];
    // 获得当前时间
    NSDate * now = [NSDate date];
    // 判断是否过期
    
    // NSOrderedAscending = -1L,   升序 -> 小于  左边小于右边
    // NSOrderedSame,               相等
    // NSOrderedDescending          降序 -> 大于  左边大于右边
    
    NSComparisonResult  result = [expire compare:now];

    if(result != NSOrderedDescending) // 过期
    {
        return nil;
    }
    
    return account;
}

@end
