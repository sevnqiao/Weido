//
//  NewFeatureViewController.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/3.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "NewFeatureViewController.h"
#import "TabBarViewController.h"

@interface NewFeatureViewController ()<UIScrollViewDelegate>
@property(nonatomic, weak)UIPageControl * page;
@end

@implementation NewFeatureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    UIScrollView * scrollView = [[UIScrollView alloc]init];
    scrollView.frame = self.view.bounds;
    CGFloat scrollW = scrollView.width;
    CGFloat scrollH = scrollView.height;
    scrollView.contentSize = CGSizeMake(4 * scrollW, 0);
    [self.view addSubview:scrollView];
    
    // 2. 添加图片到scrollView
    for(int i = 0; i<4 ;i++)
    {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.width = scrollW;
        imageView.height = scrollH;
        imageView.y = 0;
        imageView.x = i * scrollW;
        NSString * imageName = [NSString stringWithFormat:@"new_feature_%d",i+1];
        imageView.image = [UIImage imageNamed:imageName];
        [scrollView addSubview:imageView];
        
        if (i == 3) {
            [self setupLastImageView:imageView];
        }
    }
    scrollView.bounces  = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    
    
    // 添加UIPageControl: 分页控件
    UIPageControl * page = [[UIPageControl alloc]initWithFrame:CGRectMake(scrollView.centerX-50, scrollH-70, 100, 0)];
    page.numberOfPages = 4;
    page.pageIndicatorTintColor = [UIColor grayColor];
    page.currentPageIndicatorTintColor = [UIColor orangeColor];
    
    [self.view addSubview:page];
    self.page = page;
}

/**
 *  初始化最后一个imageView  , 在上面添加按钮
 */

- ( void)setupLastImageView:(UIImageView *)imageView
{
    
    imageView.userInteractionEnabled = YES;
    // 添加分享按钮
    UIButton * shareBtn = [[UIButton alloc]init];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    [shareBtn setTitle:@"  分享到微博" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    shareBtn.width = 130;
    shareBtn.height = 30;
    shareBtn.centerX = imageView.width * 0.5;
    shareBtn.centerY = imageView.height * 0.65;
    [shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:shareBtn];
    

    
    // 添加开始按钮
    UIButton * startBtn = [[UIButton alloc]init];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    [startBtn setTitle:@"开始微博" forState:UIControlStateNormal];
    startBtn.size = startBtn.currentBackgroundImage.size;
    startBtn.centerX = imageView.width * 0.5;
    startBtn.centerY = imageView.height * 0.75;
    [imageView addSubview:startBtn];
    [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];

    
}
/**
 *  点击开始按钮
 */

- (void)startClick
{
    [UIApplication sharedApplication].keyWindow.rootViewController = [[TabBarViewController alloc]init];
    
}
/**
 *  选中"分享"
 */

- (void)shareClick:(UIButton *)shareBtn
{
    // 状态取反
    shareBtn.selected = !shareBtn.isSelected;
}

#pragma mark - delegate
/**
 *  监听屏幕滚动
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (scrollView.contentOffset.x + scrollView.width * 0.5)/ scrollView.width;
    self.page.currentPage = page;
}



@end
