//
//  MXApiRequestManager.h
//  ListedCompany
//
//  Created by IOS_HMX on 15/7/20.
//  Copyright (c) 2015年 Mitake Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYQApiOperationManager : NSObject
+ (instancetype)defaultManager;
+ (instancetype)tempManager;
- (void)addOperation:(id)operation;
- (void)removeOperation:(id)operation;
- (void)removeAllOperation;
- (NSArray *)allOperation;
@end
