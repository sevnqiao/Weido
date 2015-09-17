//
//  RetweetViewController.m
//  小乔微博
//
//  Created by Sevn on 15/8/25.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "RetweetViewController.h"
#import "User.h"
#import "AccountTools.h"
#import "Account.h"
#import "PlacehoderTextView.h"
#import "HttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "ComposeToolBar.h"
#import "CommentListViewController.h"
#import "Status.h"
#import "StatusFrame.h"
#import "UIImageView+WebCache.h"
#import "Photo.h"


@interface RetweetViewController ()<ComposeToolBarDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)PlacehoderTextView * textView;
@property(nonatomic,strong)ComposeToolBar * toolBar;
@end

@implementation RetweetViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"Retweet"];
    self.navigationController.navigationBar.alpha = 1;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"Retweet"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 1. 设置导航栏
    [self setupNav];
    
    // 2. 添加输入控件
    [self setupTextView];
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    // 3. 添加工具条
    [self setupToolBar];
    
    // 4. 添加转发微博
    [self setupRetweet];
    
}


- (void)setupRetweet{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(10, 100, [UIScreen mainScreen].bounds.size.width - 2*10, 65)];
    [self.textView addSubview:view];
    view.backgroundColor = color(245, 245, 245);
    
    UIImageView * photoIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 65, 65)];
    if (self.statusFrame.status.pic_urls.count == 0) {
        NSString * str = self.statusFrame.status.user.profile_image_url;
        [photoIV sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    }
    else
    {
        Photo * photo = self.statusFrame.status.pic_urls[0];
        NSString * str = photo.thumbnail_pic;
        [photoIV sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    }
    [view addSubview:photoIV];
    
    UILabel * nameL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(photoIV.frame)+10, 10, 200, 15)];
    nameL.font = [UIFont systemFontOfSize:15];
    nameL.textColor = color(185, 185, 185);
    nameL.text = [NSString stringWithFormat:@"@%@",self.statusFrame.status.user.name];
    [view addSubview:nameL];
    
    UILabel * statusL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(photoIV.frame)+10, CGRectGetMaxY(nameL.frame)+10, [UIScreen mainScreen].bounds.size.width - CGRectGetWidth(photoIV.frame) - 2*10, 30)];
    statusL.font = [UIFont systemFontOfSize:13];
    statusL.textColor = color(185, 185, 185);
    statusL.text = self.statusFrame.status.text;
    statusL.numberOfLines = 2;
    statusL.lineBreakMode = NSLineBreakByTruncatingTail;
    [view addSubview:statusL];
    
}
- (void)setupToolBar{
    ComposeToolBar * toolBar = [[ComposeToolBar alloc]init];
    toolBar.delegate = self;
    toolBar.width = self.view.width;
    toolBar.height = 44;
    toolBar.y = self.view.height - self.toolBar.height;
    toolBar.x = 0;
    [self.view addSubview:toolBar];
    self.toolBar = toolBar;
    
    // 键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //    // 设置在键盘顶部的视图  但键盘消失的时候工具条也会消失
    //    self.textView.inputAccessoryView = toolBar;
}

- (void)keyBoardWillChangeFrame:(NSNotification *)notification{
    
    NSDictionary * userInfo = notification.userInfo;
    
    double time = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect keyBoardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:time animations:^{
        self.toolBar.y = keyBoardF.origin.y - self.toolBar.height;
    }];
    
}

- (void)setupTextView{
    PlacehoderTextView * textView = [[PlacehoderTextView alloc]init];
    // 设置文本允许垂直方向拖拽
    textView.alwaysBounceVertical = YES;
    // 设置拖拽隐藏键盘
    textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    textView.spellCheckingType = UITextSpellCheckingTypeNo;
    
    [textView becomeFirstResponder];
    
    textView.frame = self.view.bounds;
    textView.font = [UIFont systemFontOfSize:15];
    //    textView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    textView.placehoder = @"说说分享心得...";
    [self.view addSubview:textView];
    self.textView = textView;
    
}


/**  设置导航栏 */
- (void)setupNav{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancle)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
    //    self.navigationItem.rightBarButtonItem.enabled = NO;
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    NSString * Str = [NSString stringWithFormat:@"转发微博\n%@",[AccountTools account].name];
    // 创建一个带有属性的字符串
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:Str];
    // 添加属性
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(4,[AccountTools account].name.length)];
    title.numberOfLines = 0;
    title.textAlignment = NSTextAlignmentCenter;
    title.attributedText = attStr;
    self.navigationItem.titleView = title;
}

- (void)send{
    [XYQApi repostStatusWithAccessToken:[AccountTools account].access_token status:_textView.text statusID:[NSNumber numberWithLongLong:_statusID.longLongValue] type:@"POST" success:^(id json) {
        [MBProgressHUD  showSuccess:@"转发成功"];
    }];
    // 返回主界面
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancle{
    [self.textView resignFirstResponder];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 工具栏点击事件代理
- (void)composeToolBar:(ComposeToolBar *)toolBar DidClickButton:(NSUInteger)index{
    switch (index) {
        case 0: // 拍照
        {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                return;
            UIImagePickerController * ipc = [[UIImagePickerController alloc]init];
            ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
            ipc.delegate = self;
            [self presentViewController:ipc animated:YES completion:nil];
        }
            break;
        case 1: // 相册
        {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
                return;
            UIImagePickerController * ipc = [[UIImagePickerController alloc]init];
            ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            ipc.delegate = self;
            [self presentViewController:ipc animated:YES completion:nil];
        }
            break;
            //        case 2: // @
            //            <#statements#>
            //            break;
            //        case 3: // #
            //            <#statements#>
            //            break;
            //        case 4: // 表情
            //            <#statements#>
            //            break;
            
        default:
            break;
    }
}

@end
