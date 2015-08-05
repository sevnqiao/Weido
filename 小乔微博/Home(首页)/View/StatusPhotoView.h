//
//  StatusPhotoView.h
//  小乔微博
//
//  Created by 熊云桥 on 15/6/8.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Photo;

@protocol StatusesPhotoViewDelegate <NSObject>
@optional
- (void) tapImageViewTappedWithObject:(id) sender;
@end

@interface StatusPhotoView : UIImageView
@property (nonatomic , strong) Photo * photo;
@property(nonatomic,assign)id<StatusesPhotoViewDelegate> delegate;
@end
