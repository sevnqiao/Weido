//
//  StatusTool.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/10.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//  微博工具类,用来处理微博数据的缓存

#import "StatusTool.h"
#import "FMDB.h"
#import "MBProgressHUD+MJ.h"

@implementation StatusTool

static FMDatabase * _db;

+ (void)initialize
{
    // 1. 打开数据库
    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"status.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    // 2. 创建表格
    [_db executeUpdate:@"create table if not exists t_status(id integer primary key, status blob not null,idstr text not null);"];
    
    
}

+ (NSArray *)statusesWithParams:(NSDictionary *)params
{
    
    // 根据请求参数生成对应的查询SQL语句
    NSString *sql = nil;
    if (params[@"since_id"]) {
        sql = [NSString stringWithFormat:@"SELECT * FROM t_status WHERE idstr > %@ ORDER BY idstr DESC LIMIT 20;", params[@"since_id"]];
    } else if (params[@"max_id"]) {
        sql = [NSString stringWithFormat:@"SELECT * FROM t_status WHERE idstr <= %@ ORDER BY idstr DESC LIMIT 20;", params[@"max_id"]];
    } else {
        sql = @"SELECT * FROM t_status ORDER BY idstr DESC LIMIT 20;";
    }
    
    // 执行SQL
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *statuses = [NSMutableArray array];
    while (set.next) {
        NSData *statusData = [set objectForColumnName:@"status"];
        NSDictionary *status = [NSKeyedUnarchiver unarchiveObjectWithData:statusData];
        [statuses addObject:status];
    }
  
    return statuses;
}

+ (void)saveStatuses:(NSArray *)statuses
{
    // 要将一个对象存进数据库的blob字段, 最好先转为NSData
    for (NSDictionary * status in statuses) {
        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:status];
        [_db executeUpdateWithFormat:@"insert into t_status(status,idstr) values (%@,%@);",data,status[@"idstr"]];
    }
}

@end
