//
//  SettingCell.h
//  Lottery
//
//  Created by 熊云桥 on 15/5/20.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SettingItem;

@interface SettingCell : UITableViewCell

@property (nonatomic , strong) SettingItem * item;
@property (nonatomic , strong)NSIndexPath *indexPath;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
