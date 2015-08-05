//
//  PlacehoderTextView.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/9.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

// 增强 带有占位文字的textView

#import "PlacehoderTextView.h"

@implementation PlacehoderTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        
        
    }
    return self;
}

- (void)textDidChange
{
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    if (self.hasText) {
        return;
    }
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = self.font;
    dict[NSForegroundColorAttributeName] = self.placehoderColor?self.placehoderColor:[UIColor grayColor];
    CGRect placehoderRect = CGRectMake(5, 8, [UIScreen mainScreen].bounds.size.width - 2*5, rect.size.height - 2*8);
    [self.placehoder  drawInRect:placehoderRect withAttributes:dict];
}

- (void)setPlacehoder:(NSString *)placehoder
{
    _placehoder = [placehoder copy];
    [self setNeedsDisplay];
}
- (void)setPlacehoderColor:(UIColor *)placehoderColor
{
    _placehoderColor = placehoderColor;
    [self setNeedsDisplay];
}

// ----------------------------------------------------------------------------//
/**
 *  重写textView的下面四个方法
 */
- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setNeedsDisplay];
}
- (void)setTextColor:(UIColor *)textColor
{
    [super setTextColor:textColor];
    [self setNeedsDisplay];
}
- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self setNeedsDisplay];
}
- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    [self setNeedsDisplay];
}
@end
