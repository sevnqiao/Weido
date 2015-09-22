//
//  AlbumCell.m
//  SimpleCollectionViewAPI
//
//  Created by Simple Shi on 7/18/14.
//  Copyright (c) 2014 Microthink Inc,. All rights reserved.
//

#import "AlbumCell.h"

@implementation AlbumCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
//    _postImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    [self addSubview:_postImage];
//    
//    _albumName=[[UILabel alloc] initWithFrame:CGRectMake(60, 14, 66, 21)];
//    [self addSubview:_albumName];
//    
//    _photoCount=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 42, 21)];
//    [self addSubview:_photoCount];
}
-(void) setcontent:(ALAssetsGroup *)group{
    [_postImage setImage:[UIImage imageWithCGImage:group.posterImage]];
    _albumName.text=[self getAlbumName:[group valueForProperty:ALAssetsGroupPropertyName]];
    [_albumName sizeToFit];
    _photoCount.text=[NSString stringWithFormat:@"(%ld)",(long)group.numberOfAssets];
    [_photoCount sizeToFit];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSString *) getAlbumName:(NSString *) albumName{
    NSString *name=@"";
    if([albumName isEqualToString:@"My Photo Stream"]){
        name=@"我的照片流";
    }else if([albumName isEqualToString:@"Camera Roll"]){
        name=@"相机照片";
    }else{
        name=albumName;
    }
    return name;
}
@end
