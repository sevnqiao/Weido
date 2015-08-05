//
//  StatusFrame.h
//  小乔微博
//
//  Created by 熊云桥 on 15/6/5.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Status;


@interface StatusFrame : NSObject

@property (nonatomic , strong) Status * status;

@property (nonatomic,assign) CGRect originaViewF;  // 原创微博整体
@property (nonatomic,assign) CGRect iconViewF;  // 头像
@property (nonatomic,assign) CGRect photosViewF;  // 配图
@property (nonatomic,assign) CGRect vipViewF;  // vip
@property (nonatomic,assign) CGRect nameLabelF;  // 昵称
@property (nonatomic,assign) CGRect timeLabelF; // 时间
@property (nonatomic,assign) CGRect sourceLabelF; // 微博来源
@property (nonatomic,assign) CGRect contentLabelF; // 微博内容
@property (nonatomic , assign) CGFloat statusHeight; // 微博cell的高度



/**
 *  转发微博
 */
@property (nonatomic,assign) CGRect retweetViewF;
@property (nonatomic,assign) CGRect retweetContentLabelF; // 微博内容
@property (nonatomic,assign) CGRect retweetPhotosViewF;  // 配图

/**
 *  工具条
 */
@property (nonatomic , assign) CGRect toolBarF;

@end
