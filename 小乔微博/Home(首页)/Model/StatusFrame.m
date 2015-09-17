//
//  StatusFrame.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/5.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#define StatusFrameBorderW 10.0


#import "StatusFrame.h"
#import "User.h"
#import "Status.h"
#import "StatusPhotosView.h"

@interface StatusFrame()



@end

@implementation StatusFrame


- (void)setStatus:(Status *)status
{
    _status = status;
    
    User *user = status.user;
    
  //   原创微博
    
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
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelF) + StatusFrameBorderW * 0.3;
    CGSize timeSize = [status.created_at sizeWithFont:[UIFont systemFontOfSize:13]];
    self.timeLabelF = (CGRect){{timeX, timeY}, timeSize};
    
    /** 来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabelF) + StatusFrameBorderW;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithFont:[UIFont systemFontOfSize:13]];
    self.sourceLabelF = (CGRect){{sourceX, sourceY}, sourceSize};
    
    /** 正文 */
    CGFloat contentX = iconX;
    CGFloat contentY = MAX(CGRectGetMaxY(self.iconViewF), CGRectGetMaxY(self.timeLabelF)) + StatusFrameBorderW;
    CGFloat maxW = [UIScreen mainScreen].bounds.size.width - 2 * contentX;
    CGSize contentSize = [status.text sizeWithFont:[UIFont systemFontOfSize:13] maxW:maxW];
    self.contentLabelF = CGRectMake(contentX, contentY, contentSize.width, contentSize.height);
    
    /** 图片 */
    CGFloat originalH = 0;
    if (status.pic_urls.count) {
        
        CGFloat photoX = contentX;
        CGFloat photoY = CGRectGetMaxY(self.contentLabelF) + StatusFrameBorderW;
        CGSize photoSize = [StatusPhotosView photosSizeWithCount:(int)status.pic_urls.count];
        self.photosViewF = (CGRect){{photoX, photoY}, photoSize};
        
        originalH = CGRectGetMaxY(self.photosViewF) + StatusFrameBorderW;
    }
    else
    {
        originalH = CGRectGetMaxY(self.contentLabelF) + StatusFrameBorderW;
    }


    /** 原创微博整体高度 */
    CGFloat originalX = 0;
    CGFloat originalY = 0;
    CGFloat originalW = [UIScreen mainScreen].bounds.size.width;
    self.originaViewF = CGRectMake(originalX, originalY, originalW, originalH);

    
//-------------------------------------------------------------------------------------------------//
    // 工具条的Y值
    CGFloat toolBarY = 0;
    
    
    /** 转发微博 */
    
    if (status.retweeted_status) {
        Status * retweeted_status = status.retweeted_status;
        User * retweeted_status_user =retweeted_status.user;
        
        // 正文
        
        CGFloat retweetLabelX = StatusFrameBorderW;
        CGFloat retweetLabelY = StatusFrameBorderW;
        CGFloat retweetMaxX = [UIScreen mainScreen].bounds.size.width - 2 * retweetLabelX;
        NSString * retweetContent = [NSString stringWithFormat:@"@%@ : %@",retweeted_status_user.name,retweeted_status.text];
        CGSize retweetContentSize = [retweetContent sizeWithFont:[UIFont systemFontOfSize:13] maxW:retweetMaxX];
        self.retweetContentLabelF = (CGRect){{retweetLabelX, retweetLabelY}, retweetContentSize};
        
         //配图
        CGFloat retweetH = 0;
        if (retweeted_status.pic_urls.count) {
            CGFloat retweetPhotoX = retweetLabelX;
            CGFloat retweetPhotoY = CGRectGetMaxY(self.retweetContentLabelF) + StatusFrameBorderW;
            CGSize retweetPhotoSize = [StatusPhotosView photosSizeWithCount:(int)retweeted_status.pic_urls.count];
            self.retweetPhotosViewF = (CGRect){{retweetPhotoX, retweetPhotoY}, retweetPhotoSize};
            
            retweetH = CGRectGetMaxY(self.retweetPhotosViewF) +StatusFrameBorderW;
        } else { // 转发微博没有配图
            retweetH = CGRectGetMaxY(self.retweetContentLabelF) +StatusFrameBorderW;
        }
        
        // 整体高度
        CGFloat retweetViewX = 0;
        CGFloat retweetViewY = CGRectGetMaxY(self.originaViewF) ;
        CGFloat retweetViewW = [UIScreen mainScreen].bounds.size.width;
        CGFloat retweetViewH = retweetH;
        
        self.retweetViewF = CGRectMake(retweetViewX, retweetViewY, retweetViewW, retweetViewH);
        
        
        toolBarY = CGRectGetMaxY(self.retweetViewF) + 1;
        
    }
    else
    {
        toolBarY = CGRectGetMaxY(self.originaViewF) + 1;
    }
    //-------------------------------------------------------------------------------------------------//
    
    
    // 工具条
    CGFloat toolBarX = 0;
    CGFloat toolBarW = [UIScreen mainScreen].bounds.size.width;
    CGFloat toolBarH = 30;
    
    self.toolBarF = CGRectMake(toolBarX, toolBarY, toolBarW, toolBarH);
    
    self.statusHeight = CGRectGetMaxY(self.toolBarF) + 3;
    

}

@end
