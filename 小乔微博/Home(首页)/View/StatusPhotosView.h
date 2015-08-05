//
//  StatusPhotosView.h
//  小乔微博
//
//  Created by 熊云桥 on 15/6/8.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StatusesPhotosViewDelegate <NSObject>
- (void) tapImageViewsTappedWithObject:(id) sender;
@end



@interface StatusPhotosView : UIView

@property (nonatomic , strong) NSArray * photos;
@property(nonatomic,assign)id<StatusesPhotosViewDelegate>delegate;

+ (CGSize)photosSizeWithCount:(int)count;

@end
