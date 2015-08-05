//
//  CommentToolBar.h
//  小乔微博
//
//  Created by 熊云桥 on 15/6/18.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CommentToolBar;

@protocol CommentToolBarDelegate <NSObject>
@optional
- (void)commentToolBar:(CommentToolBar *)toolBar DidClickButton:(NSUInteger)index;
@end


@interface CommentToolBar : UIView
@property (nonatomic , assign) id<CommentToolBarDelegate> delegate;
@end
