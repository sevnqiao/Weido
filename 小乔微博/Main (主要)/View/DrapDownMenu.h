//
//  DrawDownMenu.h
//  小乔微博
//
//  Created by 熊云桥 on 15/6/2.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DrapDownMenu;
@protocol DrapDownMenuDelegate<NSObject>
@optional
- (void)dropdownMenuDidDismiss:(DrapDownMenu *)menu;
- (void)dropdownMenuDidShow:(DrapDownMenu *)menu;
@end


@interface DrapDownMenu : UIView
@property (nonatomic , weak) id<DrapDownMenuDelegate> delegate;

/**
 *  显示的内容
 */
@property (nonatomic , strong) UIView * content;
/**
 *  显示内容的控制器
 */
@property (nonatomic , strong) UIViewController * contentController;
/**
 *  菜单
 */
+ (instancetype)menu;
/**
 *  显示菜单
 */
- (void)showFrom:(UIView *)from;
/**
 *  销毁菜单
 */
- (void)dismiss;
@end
