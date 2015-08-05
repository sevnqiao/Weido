//
//  SaveTool.h
//  Lottery
//
//  Created by 熊云桥 on 15/5/20.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveTool : NSObject

+ (void) setObject:(id)value forKey:(NSString *)defaultName;

+ (id)objectForKey:(NSString *)defaultName;

@end
