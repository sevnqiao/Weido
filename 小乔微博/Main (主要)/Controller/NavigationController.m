//
//  NavigationController.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/2.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "NavigationController.h"


@interface NavigationController ()

@end

@implementation NavigationController
/**
 *
 */
+ (void)initialize
{
    //    设置整个项目所有item的主题样式
    UIBarButtonItem * item = [UIBarButtonItem appearance];
    
    // 设置普通状态
    NSMutableDictionary * textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置不可用状态
    // 设置普通状态
    NSMutableDictionary * DisabledAextAttrs = [NSMutableDictionary dictionary];
    DisabledAextAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    DisabledAextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [item setTitleTextAttributes:DisabledAextAttrs forState:UIControlStateDisabled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.backgroundColor = [UIColor whiteColor];
    
    //    设置整个项目所有item的主题样式
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    item = [UIBarButtonItem appearance];
    
    // 设置普通状态
    NSMutableDictionary * textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置不可用状态
    // 设置普通状态
    NSMutableDictionary * DisabledAextAttrs = [NSMutableDictionary dictionary];
    DisabledAextAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    DisabledAextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [item setTitleTextAttributes:DisabledAextAttrs forState:UIControlStateDisabled];
}
/**
 *  重写这个方法的目的: 能够拦截说有push进来的控制器
 *
 *  @param viewController 即将push进来的控制器
 *  @param animated       是否有动画
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.viewControllers.count > 0) {
        [self.view setNeedsDisplay];
        viewController.navigationController.navigationBar.alpha = 1;
        viewController.hidesBottomBarWhenPushed = YES;
        // 返回按钮
        UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        // 设置图片
        [backBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_back"] forState:UIControlStateNormal];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_back_highlighted"] forState:UIControlStateHighlighted];
        // 设置尺寸
        backBtn.size = backBtn.currentBackgroundImage.size;
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
        
        // 返回根控制器按钮
        UIButton * moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [moreBtn addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
        // 设置图片
        [moreBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_more"] forState:UIControlStateNormal];
        [moreBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_more_highlighted"] forState:UIControlStateHighlighted];
        // 设置尺寸
        moreBtn.size = moreBtn.currentBackgroundImage.size;
        
        viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:moreBtn];
    } 
    [super pushViewController:viewController animated:animated];
}

//- (UIViewController *)popViewControllerAnimated:(BOOL)animated
//{
//    UIViewController * vc = [[UIViewController alloc]init];
//    vc.navigationController.navigationBar.alpha = 1;
//    return vc;
//}


- (void)back
{
    [self popViewControllerAnimated:YES];
}

- (void)more
{
    [self popToRootViewControllerAnimated:YES];
}

@end
