//
//  RetweetViewController.h
//  小乔微博
//
//  Created by Sevn on 15/8/25.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StatusFrame;
@interface RetweetViewController : UIViewController
@property (nonatomic , copy ) NSString * statusID;
@property (nonatomic , strong) StatusFrame * statusFrame;
@end
