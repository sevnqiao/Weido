//
//  PhotoCell.m
//  SimpleCollectionViewAPI
//
//  Created by Simple Shi on 7/18/14.
//  Copyright (c) 2014 Microthink Inc,. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

- (void)awakeFromNib
{
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)imageClick_Action:(id)sender {
    UITapGestureRecognizer *tap=(UITapGestureRecognizer *)sender;
    [self.delegate imagecellSelected:self andImgTag:tap.view.tag andIndexPath:_indexPath];
}
@end
