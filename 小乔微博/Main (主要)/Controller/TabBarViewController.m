//
//  TabBarViewController.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/2.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "TabBarViewController.h"
#import "HomeViewController.h"
#import "MessageCenterViewController.h"
#import "DiscoverViewController.h"
#import "ProfileViewController.h"
#import "NavigationController.h"
#import "TabBar.h"
#import "Test1ViewController.h"
#import "ComposeViewController.h"
#import "JKPopMenuView.h"

@interface TabBarViewController ()<TabBarDelegate,JKPopMenuViewSelectDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property(nonatomic, strong)UIImage * image;
@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 1. 初始化子控制器
    self.tabBar.backgroundImage = [UIImage imageNamed:@"tabbar_background"];
    // 设置子控制器
    HomeViewController * home = [[HomeViewController alloc]init];
    [self addChildVc:home title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    MessageCenterViewController * messageCenter = [[MessageCenterViewController alloc]init];
    [self addChildVc:messageCenter title:@"消息" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    DiscoverViewController * discover = [[DiscoverViewController alloc]init];
    [self addChildVc:discover title:@"发现" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    ProfileViewController * profile = [[ProfileViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [self addChildVc:profile title:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
    
    // 2.更换系统自带的tabbar
    TabBar *tabBar = [[TabBar alloc] init];
    [self setValue:tabBar forKeyPath:@"tabBar"];
    tabBar.delegatePlus = self;
    
//    // 3. 添加一个按钮到tabBar中间位置
            // 在tabBar中定义
    
    
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString * )image selectedImage:(NSString *)selectedImage
{
    // 同时设置tabBar和navigationBar的标题文字
    childVc.title = title;

    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSMutableDictionary * textAttrs = [NSMutableDictionary dictionary];
    NSMutableDictionary * selectedtextAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = color(123, 123, 123);
    selectedtextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectedtextAttrs forState:UIControlStateSelected];
    
    NavigationController * nav = [[NavigationController alloc]initWithRootViewController:childVc];
    [self addChildViewController:nav];
}

#pragma mark - tabBarDelegate
- (void)tabBarDidClickPlusButton:(TabBar *)tabBar
{
    NSArray *array = [[NSArray alloc]init];
    
    JKPopMenuItem *item = [JKPopMenuItem itemWithTitle:@"文字" image:[UIImage imageNamed:@"icon1"] textColor:[UIColor blackColor]];
    JKPopMenuItem *item1 = [JKPopMenuItem itemWithTitle:@"相册" image:[UIImage imageNamed:@"icon2"] textColor:[UIColor blackColor]];
    JKPopMenuItem *item2 = [JKPopMenuItem itemWithTitle:@"拍摄" image:[UIImage imageNamed:@"icon3"] textColor:[UIColor blackColor]];
    JKPopMenuItem *item3 = [JKPopMenuItem itemWithTitle:@"签到" image:[UIImage imageNamed:@"icon4"] textColor:[UIColor blackColor]];
    JKPopMenuItem *item4 = [JKPopMenuItem itemWithTitle:@"点评" image:[UIImage imageNamed:@"icon5"] textColor:[UIColor blackColor]];
    JKPopMenuItem *item5 = [JKPopMenuItem itemWithTitle:@"更多" image:[UIImage imageNamed:@"icon6"] textColor:[UIColor blackColor]];
    array = @[item,item1,item2,item3,item4,item5];
    JKPopMenuView *jkpop = [JKPopMenuView menuViewWithItems:array];
    jkpop.delegate = self;
    [jkpop show];
}

- (void)popMenuViewSelectIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            ComposeViewController * comVC = [[ComposeViewController alloc]init];
            NavigationController * nav = [[NavigationController alloc]initWithRootViewController:comVC];
            [self presentViewController:nav animated:YES completion:nil];
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
        case 2: // 拍摄
        {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                return;
            UIImagePickerController * ipc = [[UIImagePickerController alloc]init];
            ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
            ipc.delegate = self;
            [self presentViewController:ipc animated:YES completion:nil];
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
        }
            break;
        default:
            break;
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    ComposeViewController * comVC = [[ComposeViewController alloc]init];
    comVC.imageView.image = image;
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:comVC];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self presentViewController:nav animated:YES completion:nil];

}
@end
