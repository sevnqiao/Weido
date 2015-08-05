//
//  IconView.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/8.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "IconView.h"
#import "UIImageView+WebCache.h"
#import "User.h"

@interface IconView()
@property(nonatomic, weak) UIImageView *verifiedView;
@end

@implementation IconView

- (UIImageView *)verifiedView
{
    if (!_verifiedView) {
        UIImageView *verifiedView = [[UIImageView alloc] init];
        [self addSubview:verifiedView];
        self.verifiedView = verifiedView;
    }
    return _verifiedView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
    }
    return self;
}

- (void)setUser:(User *)user
{
    _user = user;
    
    // 1. 下载图片
    [self sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    // 2.设置加V图片
    switch (user.verified_type) {
        case UserVerifiedTypePerson: // 个人认证
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_vip"];
            break;
            
        case UserVerifiedTypeOrgEnterprice:
        case UserVerifiedTypeOrgMedia:
        case UserVerifiedTypeWebsite: // 官方认证
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            break;
            
        case UserVerifiedTypeDaren: // 微博达人
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_grassroot"];
            break;
            
        default:
            self.verifiedView.hidden = YES; // 当做没有任何认证
            break;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.verifiedView.size = self.verifiedView.image.size;
    CGFloat scale = 0.6;
    self.verifiedView.x = self.width - self.verifiedView.width * scale;
    self.verifiedView.y = self.height - self.verifiedView.height * scale;
}
@end
