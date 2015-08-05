//
//  SettingItem.h
//  Lottery
//
//  Created by 熊云桥 on 15/5/20.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SettingItemBlock)();

@interface SettingItem : NSObject

@property (nonatomic , copy) NSString * title;
@property (nonatomic , copy) NSString * icon;
@property (nonatomic , copy) NSString * subTitle;


@property (nonatomic , strong) SettingItemBlock block;

//@property (nonatomic , assign) SettingItemType type;

+ (instancetype)itemWithIcon:(NSString *)icon withTitle:(NSString *)title;

@end
