//
//  HttpTool.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/15.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "HttpTool.h"
#import "AFNetworking.h"

@implementation HttpTool
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id json))success failure:(void(^)(NSError * error))failure
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void(^)(id json))success failure:(void(^)(NSError * error))failure
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
            
    }];
}
@end
