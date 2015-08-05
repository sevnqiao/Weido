//
//  HttpTool.h
//  小乔微博
//
//  Created by 熊云桥 on 15/6/15.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpTool : NSObject
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id json))success failure:(void(^)(NSError * error))failure;
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void(^)(id json))success failure:(void(^)(NSError * error))failure;
@end
