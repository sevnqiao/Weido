//
//  StatusPhotosView.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/8.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//


#define StatusPhotoW 75
#define StatusPhotoMargin 5
#define StatusPhotoMaxCol(count) ((count == 4) ? 2 : 3)

#import "StatusPhotosView.h"
#import "Photo.h"
#import "StatusPhotoView.h"


@interface StatusPhotosView()<StatusesPhotoViewDelegate>

@end

@implementation StatusPhotosView

+ (CGSize)photosSizeWithCount:(int)count
{
    if (count == 1) {
        return CGSizeMake(120, 120);
    }
    if (count <= 2) {
        return CGSizeMake(105, 105);
    }
    if (count <= 4) {
        return CGSizeMake(210, 210);
    }
    // 列数
    int cols = count > 2 ? 3 : count;
    CGFloat photoW = cols * StatusPhotoW + (cols - 1) * StatusPhotoMargin;
    // 行数
    int rows = 0;
    if (count % 3 == 0) {
        rows = count / 3;
    } else {
        rows = count / 3 + 1;
    }
    
    CGFloat photoH = rows * StatusPhotoW + (rows - 1) * StatusPhotoMargin;
    
    return CGSizeMake(photoW, photoH);
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    int photoCount = (int)photos.count;
    
    // 创建imageView
    while (self.subviews.count < photoCount) {
        StatusPhotoView * imageView = [[StatusPhotoView alloc] init];
        imageView.delegate = self;
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
    }
    
    for (int i = 0; i < self.subviews.count; i ++) {
        StatusPhotoView * imageView = self.subviews[i];
        
        //
        if (i< photoCount) {
            imageView.photo = photos[i];
            
            imageView.hidden = NO;
        }
        else
        {
            imageView.hidden = YES;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int photosCount = (int)self.photos.count;
    if (photosCount == 1) {
        StatusPhotoView * imageView = self.subviews[0];
        imageView.x = 0;
        imageView.y = 0;
        imageView.height = 120;
        imageView.width = 120;
        return;
    }
    if (photosCount <= 4) {
        for (int i = 0; i < photosCount; i++) {
            StatusPhotoView * imageView = self.subviews[i];
            
            int col = i % 2;
            int row = i / 2;
            imageView.x = col * (100 + StatusPhotoMargin);
            imageView.y = row * (100 + StatusPhotoMargin);
            
            imageView.height = 100;
            imageView.width = 100;
        }
        return;
    }
    for (int i = 0; i < photosCount; i++) {
        StatusPhotoView * imageView = self.subviews[i];
        
        int col = i % StatusPhotoMaxCol(photosCount);
        int row = i / StatusPhotoMaxCol(photosCount);
        imageView.x = col * (StatusPhotoW + StatusPhotoMargin);
        imageView.y = row * (StatusPhotoW + StatusPhotoMargin);

        imageView.height = StatusPhotoW;
        imageView.width = StatusPhotoW;
    }
    
    
    
}


- (void)tapImageViewTappedWithObject:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(tapImageViewsTappedWithObject:)]) {
        [self.delegate tapImageViewsTappedWithObject:sender];
    }
}

@end
