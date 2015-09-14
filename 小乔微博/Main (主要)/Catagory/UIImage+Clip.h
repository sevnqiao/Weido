//
//  UIImage+Clip.h
//  02-图片裁剪
//
//  Created by 熊云桥 on 15/5/14.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Clip)

+ (instancetype)imageWithImage:(UIImage *)image border:(CGFloat)border borderColor:(UIColor *)color;


+ (UIImage *)imageWithColor:(UIColor *)color;
@end
