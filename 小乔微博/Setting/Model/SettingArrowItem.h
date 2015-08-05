//
//  SettingArrowItem.h
//  Lottery
//
//  Created by 熊云桥 on 15/5/20.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "SettingItem.h"

@interface SettingArrowItem : SettingItem

// 调整控制器的跳转
@property (nonatomic , assign) Class destVcClass;

+ (instancetype)itemWithIcon:(NSString *)icon withTitle:(NSString *)title destVcClass:(Class)destVcClass;

@end
