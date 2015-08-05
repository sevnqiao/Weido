//
//  DrawDownMenu.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/2.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "DrapDownMenu.h"

@interface DrapDownMenu ()

@property (nonatomic , weak) UIImageView * containerView;

@end

@implementation DrapDownMenu

- (UIImageView *)containerView
{
    if (!_containerView) {
        // 添加一个灰色图片控件
        
        UIImageView * containerView = [[UIImageView alloc]init];
        UIImage * image = [UIImage imageNamed:@"popover_background"];
        containerView.image = [image stretchableImageWithLeftCapWidth:image.size.width * 1 topCapHeight:image.size.height * 0.5];
//        containerView.height = 217;
//        containerView.width = 217;
        containerView.userInteractionEnabled = YES;
        [self addSubview:containerView];
        self.containerView = containerView;
    }
    return _containerView;
}

- (void)setContent:(UIView *)content
{
    _content = content;
    
    // 调整content的位置
    content.x = 10;
    content.y = 15;
    
//    content.width = self.containerView.width - 2 * content.x;
    // 调整content的尺寸
    self.containerView.height = CGRectGetMaxY(content.frame) + 10;
    self.containerView.width = CGRectGetMaxX(content.frame) + 10;
    
    
    // 添加内容到灰色图片中
    [self.containerView addSubview:content];
}

- (void)setContentController:(UIViewController *)contentController
{
    _contentController = contentController;
    self.content = contentController.view;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        
        
        
        
    }
    return self;
}

+ (instancetype)menu
{
    return [[self alloc]init];
}

- (void)showFrom:(UIView *)from
{
    // 1. 获得一个window , 是目前显示在屏幕最上面的窗口
    UIWindow * window = [[UIApplication sharedApplication].windows lastObject];
    
    // 2. 添加自己到窗口上
    [window addSubview:self];
    
    // 3. 设置尺寸
    self.frame = window.bounds;
    
    // 4. 调整显示的位置
    //self.containerView.x = (self.width - self.containerView.width) * 0.5;
    // 默认情况下 , frame是以父控件左上角为坐标原点
    // 可以转换坐标系原点 , 改变frame的参照点
     CGRect newFrame = [from convertRect:from.bounds toView:window];
    self.containerView.y = CGRectGetMaxY(newFrame);
    self.containerView.centerX = CGRectGetMidX(newFrame);
    
    
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidShow:)]) {
        [self.delegate dropdownMenuDidShow:self];
    }

}

- (void)dismiss
{
    [self removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidDismiss:)]) {
        [self.delegate dropdownMenuDidDismiss:self];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

@end
