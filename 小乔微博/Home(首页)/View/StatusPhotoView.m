//
//  StatusPhotoView.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/8.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//  一张配图

#import "StatusPhotoView.h"
#import "Photo.h"
#import "UIImageView+WebCache.h"

@interface StatusPhotoView ()

@property(nonatomic, strong)UIImageView * gifImageView;
@property(nonatomic,strong)UIView * view;

@end

@implementation StatusPhotoView

- (UIView *)view
{
    if (!_view) {
        _view = [[UIView alloc]initWithFrame:self.frame];
    }
    return _view;
}

- (UIImageView *)gifImageView
{
    if (!_gifImageView) {
        UIImage * image = [UIImage imageNamed:@"timeline_image_gif"];
        UIImageView * gifImageView = [[UIImageView alloc]initWithImage:image];
        [self addSubview:gifImageView];
        self.gifImageView = gifImageView;
    }
    return _gifImageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        // 超出边框的内容剪裁掉
        self.clipsToBounds = YES;
        _view.frame = self.frame;
    }
    return self;
}

- (void)setPhoto:(Photo *)photo
{
    _photo = photo;
    //设置图片
    NSString * str = photo.thumbnail_pic;//[photo.thumbnail_pic stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    [self sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    
    // 显示gif图片
    // hasSuffix()后缀
    // hasPrefix()后缀
    // lowercaseString 将字符转为小写
    if ([photo.thumbnail_pic.lowercaseString hasSuffix:@"gif"]) {
        self.gifImageView.hidden = NO;
    } else {
        self.gifImageView.hidden = YES;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.gifImageView.x = self.width - self.gifImageView.width;
    self.gifImageView.y = self.height - self.gifImageView.height;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(tapImageViewTappedWithObject:WithImageView:)]) {
        [self.delegate tapImageViewTappedWithObject:_index WithImageView:self];
    }
}

@end
