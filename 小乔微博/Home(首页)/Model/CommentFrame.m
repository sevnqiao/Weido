//
//  StatusFrame.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/5.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#define StatusFrameBorderW 10.0


#import "CommentFrame.h"
#import "User.h"
#import "Comment.h"


@interface CommentFrame()
@end

@implementation CommentFrame

- (void)setComment:(Comment *)comment
{
    _comment = comment;
    
    User *user = comment.user;
    
    
    /** 头像 */
    CGFloat iconWH = 35;
    CGFloat iconX = StatusFrameBorderW;
    CGFloat iconY = StatusFrameBorderW;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    
    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + StatusFrameBorderW;
    CGFloat nameY = StatusFrameBorderW;
    CGSize nameSize = [user.name sizeWithFont:[UIFont systemFontOfSize:15]];
    self.nameLabelF = (CGRect){{nameX, nameY}, nameSize};
    
    /** 会员图标 */
    if (user.isVip) {
        CGFloat vipX = CGRectGetMaxX(self.nameLabelF) + StatusFrameBorderW;
        CGFloat vipY = StatusFrameBorderW;
        CGFloat vipH = 14.0;
        CGFloat vipW = 14.0;
        self.vipViewF = CGRectMake(vipX, vipY, vipW, vipH);
    }
    
    /** 时间 */
    CGFloat timeX = CGRectGetMaxX(self.iconViewF) + StatusFrameBorderW;;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelF) + StatusFrameBorderW * 0.3;
    CGSize timeSize = [comment.created_at sizeWithFont:[UIFont systemFontOfSize:13]];
    CGFloat timeW = [UIScreen mainScreen].bounds.size.width - CGRectGetMaxX(self.iconViewF) - StatusFrameBorderW;
    CGFloat timeH = timeSize.height;
    self.timeLabelF = CGRectMake(timeX, timeY,  timeW, timeH);
    

    /** 正文 */
    CGFloat contentX = nameX;
    CGFloat contentY = MAX(CGRectGetMaxY(self.iconViewF), CGRectGetMaxY(self.timeLabelF)) + StatusFrameBorderW;
    CGFloat maxW = [UIScreen mainScreen].bounds.size.width - 2 * contentX;
    CGSize contentSize = [comment.text sizeWithFont:[UIFont systemFontOfSize:13] maxW:maxW];
    self.contentLabelF = (CGRect){{contentX, contentY}, contentSize};
    

    
    self.commentHeight = CGRectGetMaxY(self.contentLabelF) + StatusFrameBorderW;
}

@end
