//
//  StatusToolBar.h
//  小乔微博
//
//  Created by 熊云桥 on 15/6/7.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Status;
@class StatusToolBar;

@protocol StatusToolBarDelegate <NSObject>
@optional
- (void)statusToolBar:(StatusToolBar *)toolBar DidClickButton:(int)tag;

@end




@interface StatusToolBar : UIView

@property (nonatomic , assign) id <StatusToolBarDelegate> delegate;

@property (nonatomic , strong) Status * status;
+ (instancetype)toolBar;
@end
