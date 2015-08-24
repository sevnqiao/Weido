//
//  RestoreCommentViewController.m
//  小乔微博
//
//  Created by Sevn on 15/8/19.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "RestoreCommentViewController.h"
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


@interface RestoreCommentViewController ()<ComposeToolBarDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)PlacehoderTextView * textView;
@property(nonatomic,strong)ComposeToolBar * toolBar;
@end

@implementation RestoreCommentViewController

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
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.alpha = 1;
}

- (void)setupToolBar
{
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

- (void)keyBoardWillChangeFrame:(NSNotification *)notification
{
    
    NSDictionary * userInfo = notification.userInfo;
    
    double time = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect keyBoardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:time animations:^{
        self.toolBar.y = keyBoardF.origin.y - self.toolBar.height;
    }];
    
}

- (void)setupTextView
{
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
    textView.placehoder = @"写评论...";
    [self.view addSubview:textView];
    self.textView = textView;
    
}


/**
 *  设置导航栏
 */
- (void)setupNav
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancle)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
    //    self.navigationItem.rightBarButtonItem.enabled = NO;
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    NSString * Str = [NSString stringWithFormat:@"发评论\n%@",[AccountTools account].name];
    // 创建一个带有属性的字符串
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:Str];
    // 添加属性
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(4,[AccountTools account].name.length)];
    title.numberOfLines = 0;
    title.textAlignment = NSTextAlignmentCenter;
    title.attributedText = attStr;
    self.navigationItem.titleView = title;
}

- (void)send
{
    Account * account = [AccountTools account];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"comment"] = self.textView.text;
    long long currentStatusID = self.statusID.longLongValue;
    params[@"id"] = @(currentStatusID);
    long long currentCommentID = self.idstr.longLongValue;
    params[@"cid"] = @(currentCommentID);
    
    [HttpTool post:@"https://api.weibo.com/2/comments/reply.json" params:params success:^(id json) {
        [MBProgressHUD  showSuccess:@"回复评论成功"];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];
    // 返回上个界面
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancle
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 工具栏点击事件代理
- (void)composeToolBar:(ComposeToolBar *)toolBar DidClickButton:(NSUInteger)index
{
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
