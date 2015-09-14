//
//  MXApiRequestManager.m
//  ListedCompany
//
//  Created by IOS_HMX on 15/7/20.
//  Copyright (c) 2015年 Mitake Inc. All rights reserved.
//

#import "XYQApiOperationManager.h"
#import "AFNetworking.h"
@interface XYQApiOperationManager ()
@property (nonatomic, strong) NSMutableArray *operations;
@end
@implementation XYQApiOperationManager
+ (instancetype)defaultManager {
    static XYQApiOperationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XYQApiOperationManager alloc] init];
    });
    return manager;
}

+ (instancetype)tempManager {
    static XYQApiOperationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XYQApiOperationManager alloc] init];
    });
    return manager;
}

- (NSMutableArray *)operations {
    if (!_operations) {
        _operations = [[NSMutableArray alloc] init];
    }
    return _operations;
}

- (void)addOperation:(id)operation {
    if ([self.operations indexOfObject:operation] == NSNotFound) {
        NSLog(@"加入请求:%@", ((AFHTTPRequestOperation *)operation).request);
        [self.operations addObject:operation];
        NSLog(@"所有请求数:%ld", (unsigned long)self.operations.count);
    }
}

- (void)removeOperation:(id)operation {
    if ([self.operations indexOfObject:operation] != NSNotFound) {
        NSLog(@"移除请求:%@", ((AFHTTPRequestOperation *)operation).request);
        [operation cancel];
        [self.operations removeObject:operation];
        NSLog(@"所有请求数:%ld", (unsigned long)self.operations.count);
    }
}

- (void)removeAllOperation {
    for (id operation in self.operations) {
        [operation cancel];
    }
    [self.operations removeAllObjects];
}

- (NSArray *)allOperation {
    return self.operations;
}
@end
