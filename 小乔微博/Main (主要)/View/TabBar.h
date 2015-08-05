//
//  TabBar.h
//  小乔微博
//
//  Created by 熊云桥 on 15/6/3.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabBar;
@protocol TabBarDelegate<UITabBarDelegate>
@optional

- (void)tabBarDidClickPlusButton:(TabBar *)tabBar;

@end

@interface TabBar : UITabBar
@property (nonatomic , weak) id<TabBarDelegate> delegatePlus;
@end
