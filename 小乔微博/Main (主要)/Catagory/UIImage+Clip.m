//
//  UIImage+Clip.m
//  02-图片裁剪
//
//  Created by 熊云桥 on 15/5/14.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "UIImage+Clip.h"

@implementation UIImage (Clip)

+ (instancetype)imageWithImage:(UIImage *)image border:(CGFloat)border borderColor:(UIColor *)color
{
    // 圆环宽度
    CGFloat borderW = border;
    
    // 加载旧图片
    UIImage * oldImage = image;
    
    // 新的图片尺寸
    CGFloat imageW = oldImage.size.width + 2 * borderW;
//    CGFloat imageH = oldImage.size.height + 2 *borderW;
    
    //获取矩形图片的最小园半径
    CGFloat circilW = imageW;
    
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(circilW  , circilW), NO, 0.0);
    
    // 画大圆
    UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, circilW, circilW)];
    
    // 添加到上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [color set];
    
    CGContextAddPath(ctx, path.CGPath);
    
    CGContextFillPath(ctx);
    
    CGRect rect =  CGRectMake(borderW, borderW, oldImage.size.width, oldImage.size.height);
    
    // 画正切于旧图片的圆
    UIBezierPath * path1 = [UIBezierPath bezierPathWithOvalInRect:rect];
    
    // 设为裁剪区
    [path1 addClip];
    
    // 画图片
    [oldImage drawAtPoint:CGPointMake(borderW, borderW)];
    
    // 获取新的图片
    UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newimage;
}


+ (UIImage *)imageWithColor:(UIColor *)color
{
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}
@end
