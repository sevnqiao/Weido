//
//  ComposeToolBar.h
//  小乔微博
//
//  Created by 熊云桥 on 15/6/12.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ComposeToolBar;
@protocol ComposeToolBarDelegate <NSObject>
@optional
- (void)composeToolBar:(ComposeToolBar *)toolBar DidClickButton:(NSUInteger)index;
@end


@interface ComposeToolBar : UIView
@property (nonatomic , assign) id<ComposeToolBarDelegate> delegate;
@end
