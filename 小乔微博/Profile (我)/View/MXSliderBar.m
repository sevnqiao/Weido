//
//  MXSliderBar.m
//  MXCustomView
//
//  Created by IOS_HMX on 15/7/7.
//  Copyright (c) 2015年 IOS_HMX. All rights reserved.
//

#import "MXSliderBar.h"
//#import "UIColor+Additions.h"
static const NSInteger kTitleSize = 16;

@interface MXSliderBar ()
@property(nonatomic,strong)CALayer *backLayer;
@property(nonatomic,copy)NSArray *titles;
@property(nonatomic,strong)NSMutableArray *titlesButton;
@end
@implementation MXSliderBar
-(instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titles = titles;
        self.titlesButton = [NSMutableArray arrayWithCapacity:titles.count];
        [self configView];
        self.selectIndex = 1;
    }
    return self;
}
-(void)layoutSubviews
{
    CGFloat width = CGRectGetWidth(self.frame)/self.titles.count;
    CGFloat height = CGRectGetHeight(self.frame);
    for (int i =0; i<self.titles.count; i++) {
        UIButton *but = (UIButton *)self.titlesButton[i];
        but.frame = CGRectMake( width*i, 0, width, height);
    }
    [self setLayerPosition:self.selectIndex];
}
-(void)configView
{
    for (int i = 0; i<self.titles.count; i++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.backgroundColor = [UIColor clearColor];
        but.titleLabel.font = [UIFont systemFontOfSize:kTitleSize];
        [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [but setTitle:self.titles[i] forState:UIControlStateNormal];
        but.tag = i;
        [but addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:but];
        [self.titlesButton addObject:but];
    }
    CGFloat layerW = 79;
    CGFloat layerH = 26;//kTitleSize + 15;
    self.backLayer = [CALayer layer];
    self.backLayer.frame = CGRectMake(0, 0, layerW, layerH);
    self.backLayer.borderColor = color(255, 131, 21).CGColor;
    self.backLayer.borderWidth = 1.;
    self.backLayer.cornerRadius = layerH/2;
    self.backLayer.masksToBounds = YES;
    [self.layer insertSublayer:self.backLayer atIndex:0];
    
}
-(void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    [self setTitleButtonColor:selectIndex];
    [self setLayerPosition:selectIndex];
}
-(void)clickButton:(UIButton *)button
{
    self.selectIndex = button.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderBar:selectAtIndex:)]) {
        [self.delegate sliderBar:self selectAtIndex:button.tag];
    }
}
-(void)setTitleButtonColor:(NSInteger)index
{
    for (UIButton *b in self.titlesButton) {
        if (b.tag == index) {
            [b setTitleColor:color(38, 38, 38) forState:UIControlStateNormal];
        }else
        {
            [b setTitleColor:color(111, 111, 111) forState:UIControlStateNormal];
        }
    }
}
-(void)setLayerPosition:(NSInteger)index
{
    CGFloat width = CGRectGetWidth(self.frame)/self.titles.count;
    CGFloat height = CGRectGetHeight(self.frame);
    self.backLayer.position = CGPointMake(width/2+width*index, height/2);
}
@end
