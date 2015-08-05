//
//  ProductCell.m
//  Lottery
//
//  Created by 熊云桥 on 15/5/20.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "ProductCell.h"
#import "Product.h"

@interface ProductCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ProductCell

- (void)awakeFromNib
{
    _imageView.layer.cornerRadius = 10;
    _imageView.clipsToBounds = YES;
}


- (void)setProduct:(Product *)product
{
    _product = product;
    
    _imageView.image = [UIImage imageNamed:product.icon];
    _label.text = product.title;
}

@end
