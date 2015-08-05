//
//  StatusFrame.h
//  小乔微博
//
//  Created by 熊云桥 on 15/6/5.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Comment;


@interface CommentFrame : NSObject

@property (nonatomic , strong) Comment * comment;

@property (nonatomic,assign) CGRect originaViewF;  // 整体
@property (nonatomic,assign) CGRect iconViewF;  // 头像
@property (nonatomic,assign) CGRect vipViewF;  // vip
@property (nonatomic,assign) CGRect nameLabelF;  // 昵称
@property (nonatomic,assign) CGRect timeLabelF; // 时间
@property (nonatomic,assign) CGRect contentLabelF; // 内容
@property (nonatomic,assign) CGFloat commentHeight; // cell的高度




@end
