//
//  MyAttentionViewTableViewCell.h
//  小乔微博
//
//  Created by Sevn on 15/8/18.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User,Status;

@interface MyAttentionViewTableViewCell : UITableViewCell

@property(nonatomic,strong)User *user;

@property(nonatomic,assign)CGFloat cellHeight;

@end
