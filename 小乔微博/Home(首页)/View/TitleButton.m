//
//  TitieButton.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/4.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "TitleButton.h"

@implementation TitleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        
        self.imageView.contentMode = UIViewContentModeCenter;
        
        //
//        self.backgroundColor = [UIColor redColor];
//        self.imageView.backgroundColor = [UIColor yellowColor];
//        self.titleLabel.backgroundColor = [UIColor blueColor];
    }
    return self;
}
/**
 *  设置按钮内部imageView的frame
 *
 *  @param contentRect 按钮的bounds
 
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    
    CGFloat imageX = 80;
    CGFloat imageY = 0;
    CGFloat imageW = 26;
    CGFloat imageH = contentRect.size.height;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}
**
 *  设置按钮内部titleView的frame
 *
 *  @param contentRect 按钮的bounds
 
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0 ;
    CGFloat titleY = 0 ;
    CGFloat titleW = 80 ;
    CGFloat titleH = contentRect.size.height ;
    return CGRectMake(titleX, titleY, titleW, titleH);
}
*/

/**
 *  如果仅仅只是调整按钮内部的titlelabel和imageView的位置,就在layoutSubviews中单独设置即可
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1. 计算titleLabel的frame
//    NSMutableDictionary * attrs = [NSMutableDictionary dictionary];
//    attrs[NSFontAttributeName] = self.titleLabel.font;
//    CGFloat titleW = [self.currentTitle sizeWithAttributes:attrs].width;
    
    self.titleLabel.x = self.imageView.x;

//    // 2. 计算imageView的frame
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame);
    
}

@end
