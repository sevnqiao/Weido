//
//  WhisperCell.h
//  小乔微博
//
//  Created by Sevn on 15/8/20.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Comment;

@protocol WhisperCellGelegate<NSObject>
@optional
- (void)replyWithCommentID:(NSString *)commentIDstr CommentStatusID:(NSString *)statusIDstr;

@end

@interface WhisperCell : UITableViewCell

@property(nonatomic,strong)Comment *comment;
@property (nonatomic,assign) CGFloat cellHeight; // 微博cell的高度
@property(nonatomic,assign)id<WhisperCellGelegate>delegate;
@end
