//
//  UserDetialView.m
//  小乔微博
//
//  Created by kenny on 15/7/7.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "UserDetialView2.h"
#import "MBProgressHUD+MJ.h"
#import "Account.h"
#import "AccountTools.h"
#import "HttpTool.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Clip.h"

@interface UserDetialView2()
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property(nonatomic,strong)NSString *name;;
@end


@implementation UserDetialView2

- (NSString *)name
{
    if (!_name) {
        _name = [[NSString alloc]init];
    }
    return _name;
}
- (instancetype)initWithFrame:(CGRect)frame userName:(NSString *)userName
{
    self = [super initWithFrame:frame];
    if (self) {
        self.name = userName;
        self = [[NSBundle mainBundle] loadNibNamed:@"UserDetialView2" owner:nil options:nil].firstObject;
        [self setupDetialWithUserName:userName];
      
    }
    return self;
}
- (void)setupDetialWithUserName:(NSString *)userName
{
    [MBProgressHUD showMessage:@"正在努力加载中..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Account * account = [AccountTools account];
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"access_token"] = account.access_token;
        params[@"screen_name"] = @"熊桥桥桥桥桥桥";
        [HttpTool get:@"https://api.weibo.com/2/users/show.json" params:params success:^(id json) {
            self.nameLabel.text = json[@"name"];
            self.descriptionLabel.text = [NSString stringWithFormat:@"简介 : %@",json[@"description"]];
            UIImageView * imageView = [[UIImageView alloc]init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:json[@"profile_image_url"]] placeholderImage:[UIImage imageNamed:@"album"]];
//            self.icon.layer.cornerRadius = 10;
            self.icon.image = [UIImage imageWithImage:imageView.image border:1.0 borderColor:[UIColor clearColor]];
            self.attentionLabel.text =  [NSString stringWithFormat:@"关注数 : %@",[json[@"friends_count"] stringValue]];
            self.fansLabel.text = [NSString stringWithFormat:@"粉丝数 : %@",[json[@"followers_count"] stringValue] ];
            
            [MBProgressHUD hideHUD];
        } failure:^(NSError *error) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
        }];
    });
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.icon.layer.cornerRadius = 10;
}
@end
