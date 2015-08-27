//
//  AlbumCell.h
//  SimpleCollectionViewAPI
//
//  Created by Simple Shi on 7/18/14.
//  Copyright (c) 2014 Microthink Inc,. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface AlbumCell : UITableViewCell

@property (nonatomic, strong) UIImageView *postImage;
@property (nonatomic, strong) UILabel *albumName;
@property (nonatomic, strong) UILabel *photoCount;
-(void) setcontent:(ALAssetsGroup *) group;
@end
