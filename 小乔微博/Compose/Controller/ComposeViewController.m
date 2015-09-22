 //
//  ComposeViewController.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/8.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#define StatusPhotoW ([UIScreen mainScreen].bounds.size.width - 4*10)/3
#define StatusPhotoMargin 10


#import "ComposeViewController.h"
#import "User.h"
#import "AccountTools.h"
#import "Account.h"
#import "PlacehoderTextView.h"
#import "HttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "ComposeToolBar.h"
#import "CoreEmotionView.h"
#import "NSArray+SubArray.h"
#import "EmotionModel.h"
#import "NSString+EmotionExtend.h"
#import "AFNetworking.h"
#import "UserAlbumListView.h"
#import "NavigationController.h"

@interface ComposeViewController ()<ComposeToolBarDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>
@property(nonatomic,strong)PlacehoderTextView * textView;
@property(nonatomic,strong)ComposeToolBar * toolBar;

@property (nonatomic,strong) CoreEmotionView *emotionView;

@end

@implementation ComposeViewController

-(CoreEmotionView *)emotionView{
    
    if(_emotionView==nil){
        _emotionView = [CoreEmotionView emotionView];
    }
    
    return _emotionView;
}

- (NSMutableArray *)imagesArr
{
    if (!_imagesArr) {
        _imagesArr = [NSMutableArray array];
    }
    return _imagesArr;
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
    
    if (_imagesArr.count != 0) {
        for (int i=0;i<_imagesArr.count; i++) {
            UIImageView * imageView = [[UIImageView alloc]init];;
            int col = i % 3;
            int row = i / 3;
            imageView.x = col * (StatusPhotoW + StatusPhotoMargin) + 10;
            imageView.y = row * (StatusPhotoW + StatusPhotoMargin) + 100;
            imageView.height = StatusPhotoW;
            imageView.width = StatusPhotoW;
            imageView.image = _imagesArr[i];
            [self.textView addSubview:imageView];
        }
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Return_Image_Action:) name:@"RETURN_IMAGE_SELECT" object:nil];
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
    self.textView = [[PlacehoderTextView alloc]init];
    // 设置文本允许垂直方向拖拽
    self.textView.alwaysBounceVertical = YES;
    // 设置拖拽隐藏键盘
    self.textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.textView.spellCheckingType = UITextSpellCheckingTypeNo;
    
    [self.textView becomeFirstResponder];
    
    self.textView.frame = self.view.bounds;
    self.textView.font = [UIFont systemFontOfSize:15];
//    textView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.textView.placehoder = @"分享新鲜事...";
    [self.view addSubview:self.textView];

    
    self.emotionView.textView=self.textView;
    
    self.textView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth=.5f;
    
    //设置代理
    self.textView.delegate=self;
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
}


/**
 *  设置导航栏
 */
- (void)setupNav
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(send)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancle)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor lightGrayColor]];

    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    NSString * Str = [NSString stringWithFormat:@"发微博\n%@",[AccountTools account].name];
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
    if (self.imagesArr.count == 0)
    {
        [self sendWithOutImage];
    }
    else
    {
        [self sendWithImage];
    }
}

- (void)sendWithOutImage
{
    [XYQApi ComposeWithOutImageStatus:self.emotionView.textView.text type:@"POST" accessToken:[AccountTools account].access_token success:^(id json) {
        [MBProgressHUD  showSuccess:@"发送成功"];
    }];
    // 返回主界面
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendWithImage
{
    [self.textView resignFirstResponder];
    Account * account = [AccountTools account];
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"status"] = self.emotionView.textView.text;
    NSString * URL = [[NSString alloc]init];
    
    if ([self.textView.text isEqualToString:@""]) {
        params[@"status"] = @"分享图片";
    }
    URL = @"https://upload.api.weibo.com/2/statuses/upload.json";
    
    
    [manager POST:URL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // 拼接文件数据
        for(UIImage *image in _imagesArr)
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            
            NSData *data = UIImageJPEGRepresentation(image, 1.0);
            [formData appendPartWithFileData:data name:@"pic" fileName:fileName mimeType:@"image/png"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD  showSuccess:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
    }];
    // 返回主界面
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancle
{
    [_imagesArr removeAllObjects];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 工具栏点击事件代理
- (void)composeToolBar:(ComposeToolBar *)toolBar DidClickButton:(NSUInteger)index
{
    [_imagesArr removeAllObjects];
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
//            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
//                return;
//            UIImagePickerController * ipc = [[UIImagePickerController alloc]init];
//            ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            ipc.delegate = self;
//            [self presentViewController:ipc animated:YES completion:nil];
            
            UserAlbumListView * userAlbum = [[UserAlbumListView alloc]init];
            NavigationController * nav = [[NavigationController alloc]initWithRootViewController:userAlbum];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
            break;
//        case 2: // @
//
//            break;
//        case 3: // #
//
//            break;
        case 4: // 表情
        {
            [self.textView resignFirstResponder];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.15f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.textView.inputView=self.textView.inputView?nil:self.emotionView;
                [self.textView becomeFirstResponder];
            });
        }
            break;
            
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_imagesArr addObject:image];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 100, 100, 100)];
    imageView.image = image;
    [self.textView addSubview:imageView];
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void) Return_Image_Action:(NSNotification *) notification{
    _imagesArr = [notification userInfo][@"images"];
    for (int i=0;i<_imagesArr.count; i++) {
        UIImageView * imageView = [[UIImageView alloc]init];;
        int col = i % 3;
        int row = i / 3;
        imageView.x = col * (StatusPhotoW + StatusPhotoMargin) + 10;
        imageView.y = row * (StatusPhotoW + StatusPhotoMargin) + 100;
        imageView.height = StatusPhotoW;
        imageView.width = StatusPhotoW;
        imageView.image = _imagesArr[i];
        [self.textView addSubview:imageView];
    }
}

#pragma mark - 编辑框代理
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor orangeColor]];
    }
    else
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

@end
