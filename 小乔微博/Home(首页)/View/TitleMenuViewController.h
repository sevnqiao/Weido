//
//  TitleMenuViewController.h
//  小乔微博
//
//  Created by 熊云桥 on 15/6/2.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TitleMenuViewController;
@protocol TitleMenuViewControllerDelegate <NSObject>
@optional
- (void)willSelectRow;
- (void)titleMenuviewController:(TitleMenuViewController *)titleMenuviewController didSelectedRowToRefreshStatusesFrame:(NSMutableArray *)statusesFrame title:(NSString *)title;
@end

@interface TitleMenuViewController : UITableViewController
@property(nonatomic,assign)id<TitleMenuViewControllerDelegate>delegate;

@end
