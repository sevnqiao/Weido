//
//  UserPhotosListCollectionViewController.m
//  小乔微博
//
//  Created by Sevn on 15/9/29.
//  Copyright © 2015年 Mr.X. All rights reserved.
//

#warning 添加跳转微博

#import "UserPhotosListCollectionViewController.h"
#import "PhotosListCollectionViewCell.h"
#import "MMLocationManager.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "User.h"
#import "Status.h"
#import "HZPhotoBrowser.h"

@interface UserPhotosListCollectionViewController ()<HZPhotoBrowserDelegate,PhotosListCollectionViewCellDelegate>
@property(nonatomic,strong)UIImageView *pictureView;
@property(nonatomic,strong)NSMutableArray *PhotoUrlsArr;
@property(nonatomic,assign)CGFloat latitude;
@property(nonatomic,assign)CGFloat longitude;
@property(nonatomic,strong)NSMutableArray *poisArr;
@property(nonatomic,assign)int page;
@end

@implementation UserPhotosListCollectionViewController

static NSString * const reuseIdentifier = @"Cell";


- (instancetype)init{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    
    layout.itemSize = CGSizeMake((KScreen_W - 2) / 3 - 1 , KScreen_W / 3);
    
    layout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
    
    layout.minimumLineSpacing = 1;
    
    layout.minimumInteritemSpacing = 1;

    if (self = [super initWithCollectionViewLayout:layout]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _poisArr = [NSMutableArray array];
    _PhotoUrlsArr = [NSMutableArray array];
    _page = 1;
    self.collectionView.backgroundColor = color(247, 247, 247);
    [self.collectionView registerClass:[PhotosListCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self getUserLocation];
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView addHeaderWithTarget:self action:@selector(loadNew)];
    [self.collectionView addFooterWithTarget:self action:@selector(loadMore)];
   
}
 // 1 . 先获取位置坐标
- (void)getUserLocation
{
    __block __weak UserPhotosListCollectionViewController *weakSelf = self;
    [[MMLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        weakSelf.latitude = locationCorrrdinate.latitude;
        weakSelf.longitude = locationCorrrdinate.longitude;
    } withAddress:^(NSString *addressString) {
        //        weakSelf.addressString = addressString;
        
    }];
    [self getPhotoList];
}
 // 2. 根据位置坐标获取地点列表
- (void)getPhotoList{
    [MBProgressHUD showMessage:@"正在加载中"];
    NSString *str1 = [NSString stringWithFormat:@"https://api.weibo.com/2/place/nearby/pois.json?access_token=2.00PBkLBEU3TPLB3b10a0df3a0ZuXR3&uid=3682106173&lat=%f&long=%f",_latitude,_longitude];
    NSURL *url=[NSURL URLWithString:str1];//创建URL
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];//通过URL创建网络请求
    [request setTimeoutInterval:30];//设置超时时间
    [request setHTTPMethod:@"GET"];//设置请求方式
    NSError *err;
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *arr = rootDic[@"pois"];
    for (NSDictionary *dict in arr) {
        [_poisArr addObject:dict[@"poiid"]];
    }
    [MBProgressHUD hideHUD];
}

 // 3. 根据地点获取附近照片
- (void)loadNew{
    [MBProgressHUD showMessage:@"正在加载中"];
    NSString *str1 = [NSString stringWithFormat:@"https://api.weibo.com/2/place/pois/photos.json?access_token=2.00PBkLBEU3TPLB3b10a0df3a0ZuXR3&uid=3682106173&poiid=%@&page=%d",_poisArr[0],1];
    NSURL *url=[NSURL URLWithString:str1];//创建URL
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];//通过URL创建网络请求
    [request setTimeoutInterval:30];//设置超时时间
    [request setHTTPMethod:@"GET"];//设置请求方式
    NSError *err;
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *arr = rootDic[@"statuses"];
    if (arr.count != 0) {
        [_PhotoUrlsArr removeAllObjects];
    }
    for (NSDictionary *dict in arr) {
        Status *status = [Status objectWithKeyValues:dict];
        [_PhotoUrlsArr addObject:status];
    }
    [MBProgressHUD hideHUD];
    [self.collectionView reloadData];
    [self.collectionView headerEndRefreshing];
    _page = 1;
}
 // 获取更多照片
- (void)loadMore{
    _page = _page + 1;
    [MBProgressHUD showMessage:@"正在加载中"];
    NSString *str1 = [NSString stringWithFormat:@"https://api.weibo.com/2/place/pois/photos.json?access_token=2.00PBkLBEU3TPLB3b10a0df3a0ZuXR3&uid=3682106173&poiid=%@&page=%d",_poisArr[0],_page];
    NSURL *url=[NSURL URLWithString:str1];//创建URL
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];//通过URL创建网络请求
    [request setTimeoutInterval:30];//设置超时时间
    [request setHTTPMethod:@"GET"];//设置请求方式
    NSError *err;
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *arr = rootDic[@"statuses"];
    for (NSDictionary *dict in arr) {
        Status *status = [Status objectWithKeyValues:dict];
        [_PhotoUrlsArr addObject:status];
    }
    [MBProgressHUD hideHUD];
    [self.collectionView reloadData];
    [self.collectionView footerEndRefreshing];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _PhotoUrlsArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotosListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    Status *status = _PhotoUrlsArr[indexPath.row];
    cell.index = (int)indexPath.row;
    [cell.pictureView sd_setImageWithURL:[NSURL URLWithString:status.original_pic] placeholderImage:[UIImage imageNamed:@"album"]];
    return cell;
}

- (void)didClickPhotoWithObjects:(int)index WithImageView:(UIView *)imageView{
    HZPhotoBrowser *browserVc = [[HZPhotoBrowser alloc] init];
    browserVc.sourceImagesContainerView = imageView; // 原图的父控件
    browserVc.imageCount = _PhotoUrlsArr.count; // 图片总数
    browserVc.currentImageIndex = index;
    browserVc.delegate = self;
    [browserVc show];
}

#pragma mark - HZPhotoBrowserDelegate
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    Status *status = _PhotoUrlsArr[index];
    NSString *urlStr = status.original_pic;
    
    UIImageView * imageView = [[UIImageView alloc]init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    
    return imageView.image;
}

- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    Status *status = _PhotoUrlsArr[index];
    return [NSURL URLWithString:status.original_pic];
}



@end
