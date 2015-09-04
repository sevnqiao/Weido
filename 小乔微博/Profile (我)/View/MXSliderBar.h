//
//  MXSliderBar.h
//  MXCustomView
//
//  Created by IOS_HMX on 15/7/7.
//  Copyright (c) 2015年 IOS_HMX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MXSliderBar;

@protocol MXSliderBarDelegate <NSObject>
@optional
-(void)sliderBar:(MXSliderBar *)sliderBar selectAtIndex:(NSInteger)index;

@end

@interface MXSliderBar : UIView
@property(nonatomic,assign,readwrite)NSInteger selectIndex;
@property(nonatomic,assign)id<MXSliderBarDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles;
@end
