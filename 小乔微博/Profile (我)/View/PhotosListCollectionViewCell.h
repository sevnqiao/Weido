//
//  PhotosListCollectionViewCell.h
//  小乔微博
//
//  Created by Sevn on 15/9/29.
//  Copyright © 2015年 Mr.X. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotosListCollectionViewCellDelegate <NSObject>
@optional
- (void)didClickPhotoWithObjects:(int)index WithImageView:(UIView *)imageView;
@end

@interface PhotosListCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *pictureView;
@property(nonatomic,strong)UIView *view;
@property(nonatomic,assign)int index;
@property(nonatomic,assign)id<PhotosListCollectionViewCellDelegate>delegate;
@end
