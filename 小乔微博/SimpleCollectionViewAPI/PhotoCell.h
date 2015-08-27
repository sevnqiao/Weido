//
//  PhotoCell.h
//  SimpleCollectionViewAPI
//
//  Created by Simple Shi on 7/18/14.
//  Copyright (c) 2014 Microthink Inc,. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageSelectedDelegate <NSObject>
-(void) imagecellSelected:(UITableViewCell *)cell andImgTag:(NSInteger) tag andIndexPath:(NSIndexPath *) indexPath;
@end

@interface PhotoCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *image1;
@property (nonatomic, weak) IBOutlet UIImageView *image2;
@property (nonatomic, weak) IBOutlet UIImageView *image3;
@property (nonatomic, weak) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UIImageView *selected1;
@property (weak, nonatomic) IBOutlet UIImageView *selected2;
@property (weak, nonatomic) IBOutlet UIImageView *selected3;
@property (weak, nonatomic) IBOutlet UIImageView *selected4;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (weak) id<ImageSelectedDelegate> delegate;

- (IBAction)imageClick_Action:(id)sender;
@end
