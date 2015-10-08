//
//  PhotosListCollectionViewCell.m
//  小乔微博
//
//  Created by Sevn on 15/9/29.
//  Copyright © 2015年 Mr.X. All rights reserved.
//

#import "PhotosListCollectionViewCell.h"

@implementation PhotosListCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, (KScreen_W - 2) / 3 - 1, KScreen_W/3)];
        UIImageView *pictureView = [[UIImageView alloc]initWithFrame:view.frame];
        pictureView.backgroundColor = [UIColor whiteColor];
        pictureView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [pictureView addGestureRecognizer:tap];
        [view addSubview:pictureView];
        [self addSubview:view];
        _pictureView = pictureView;
    }
    return self;
}

- (void)tap{
    if ([self.delegate respondsToSelector:@selector(didClickPhotoWithObjects:WithImageView:)]) {
        [self.delegate didClickPhotoWithObjects:_index WithImageView:_view];
    }
}

@end
