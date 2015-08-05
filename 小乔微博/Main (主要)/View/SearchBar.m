//
//  SearchBar.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/2.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "SearchBar.h"

@implementation SearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.background = [[UIImage imageNamed:@"searchbar_textfield_background"]stretchableImageWithLeftCapWidth:1 topCapHeight:1];
        self.width = 300;
        self.height = 35;
        
        self.font = [UIFont systemFontOfSize:14];
        self.placeholder = @"请输入搜索条件";
        
        // 设置左边放大镜图标
        UIImageView * searchIcon = [[UIImageView alloc]init];
        searchIcon.image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
        searchIcon.contentMode = UIViewContentModeCenter;
        searchIcon.height = 30;
        searchIcon.width = 30;
        
        self.leftView = searchIcon;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

+ (instancetype)searchBar
{
    return [[self alloc]init];
}

@end
