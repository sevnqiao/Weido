//
//  ProfileHeaderView.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/14.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "ProfileHeaderView.h"
#import "UIImageView+WebCache.h"
#import "HttpTool.h"
#import "Account.h"
#import "AccountTools.h"
#import "MBProgressHUD+MJ.h"

@interface ProfileHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *attentionCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;


@property (weak, nonatomic) IBOutlet UIView *myStatus;
@property (weak, nonatomic) IBOutlet UIView *myAttention;
@property (weak, nonatomic) IBOutlet UIView *myFans;


@end

@implementation ProfileHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"ProfileHeaderView" owner:nil options:nil].lastObject;
        
        [self setupProfile];
        
        self.myStatus.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click1)];
        [self.myStatus addGestureRecognizer:tap];
        
//        self.myAttention.userInteractionEnabled = YES;
//        UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click2)];
//        [self.myStatus addGestureRecognizer:tap2];
//        
//        self.myFans.userInteractionEnabled = YES;
//        UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click3)];
//        [self.myStatus addGestureRecognizer:tap3];
    }
    return self;
}

- (void)click1
{
    if ([self.delegate respondsToSelector:@selector(setupMyStatusDetailDidFinishTap)]) {
        [self.delegate setupMyStatusDetailDidFinishTap];
    }
}
//- (void)click2
//{
//    if ([self.delegate respondsToSelector:@selector(setupMyAttentionDetailDidFinishTap)]) {
//        [self.delegate setupMyAttentionDetailDidFinishTap];
//    }
//}
//- (void)click3
//{
//    if ([self.delegate respondsToSelector:@selector(setupMyFansDetailDidFinishTap)]) {
//        [self.delegate setupMyFansDetailDidFinishTap];
//    }
//}


- (void)setupProfile
{
    [MBProgressHUD showMessage:@"正在努力加载中..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Account * account = [AccountTools account];
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"access_token"] = account.access_token;
        params[@"uid"] = account.uid;
        [HttpTool get:@"https://api.weibo.com/2/users/show.json" params:params success:^(id json) {
            self.nameLabel.text = json[@"name"];
            self.descriptionLabel.text = [NSString stringWithFormat:@"简介 : %@",json[@"description"]];
            [self.iconView sd_setImageWithURL:[NSURL URLWithString:json[@"profile_image_url"]] placeholderImage:[UIImage imageNamed:@"album"]];
            self.statusCountLabel.text = [json[@"statuses_count"] stringValue];
            self.attentionCountLabel.text = [json[@"friends_count"] stringValue];
            self.fansCountLabel.text = [json[@"followers_count"] stringValue];
            
            [MBProgressHUD hideHUD];
        } failure:^(NSError *error) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
        }];
    });

}
    
@end
