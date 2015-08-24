//
//  MyFansTableViewCell.h
//  小乔微博
//
//  Created by Sevn on 15/8/18.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;

@protocol  UITableViewCellDelegate <NSObject>
@optional
- (void) cancelAttentionWithIdStr:(NSString *)idstr;
- (void) addAttentionWithIdStr:(NSString *)idstr;
@end

@interface MyFansTableViewCell : UITableViewCell
@property(nonatomic,strong)User *user;

@property(nonatomic,assign)CGFloat cellHeight;

@property(nonatomic,assign)id<UITableViewCellDelegate>delegate;
@end
