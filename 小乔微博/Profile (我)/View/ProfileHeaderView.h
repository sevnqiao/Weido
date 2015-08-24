//
//  ProfileHeaderView.h
//  小乔微博
//
//  Created by 熊云桥 on 15/6/14.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfileHeaderViewDelegate <NSObject>
@required
- (void)setupMyDetialDidFinishTap;
- (void)setupMyStatusDetailDidFinishTap;
- (void)setupMyAttentionDetailDidFinishTap;
- (void)setupMyFansDetailDidFinishTap;
@end

@interface ProfileHeaderView : UIView
@property (nonatomic , assign) id<ProfileHeaderViewDelegate>delegate;
@end
