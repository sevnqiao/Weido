//
//  AlbumPhotosListView.m
//  SimpleCollectionViewAPI
//
//  Created by Simple Shi on 7/18/14.
//  Copyright (c) 2014 Microthink Inc,. All rights reserved.
//
#import "AlbumPhotosListView.h"
#import "PhotoCell.h"

#define MAXIMAGE 9

@interface AlbumPhotosListView ()<ImageSelectedDelegate>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UILabel *selectCount;
@end

@implementation AlbumPhotosListView
@synthesize dataSource,assetGroup,selectCount,selectImages;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    dataSource=[NSMutableArray array];
    selectImages=[NSMutableArray array];
    CGRect viewFrame=self.view.frame;
    self.maintableview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewFrame.size.width, viewFrame.size.height-44) style:UITableViewStylePlain];
    [self.maintableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.maintableview.backgroundColor = color(235, 235, 235);
    [self.maintableview setDelegate:self];
    [self.maintableview setDataSource:self];
    [self.view addSubview:self.maintableview];
    
    
    UIToolbar *toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, viewFrame.size.height-44, 320, 44)];
    toolBar.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.textColor = [UIColor blackColor];
    [btn addTarget:self action:@selector(preView_Action) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"已选" forState:UIControlStateNormal];
    btn.titleLabel.textColor = [UIColor blackColor];
    [btn setFrame:CGRectMake(10, 5, 50, 30)];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
//    [btn setBackgroundColor:[UIColor colorWithRed:0/255.0 green:127/255.0 blue:245/255.0 alpha:1.0f]];
//    [btn.layer setCornerRadius:3.0f];
    
    selectCount=[[UILabel alloc] initWithFrame:CGRectMake(39, -4, 16, 16)];
    selectCount.backgroundColor=[UIColor redColor];
    [selectCount.layer setBorderColor:[UIColor whiteColor].CGColor];
    [selectCount.layer setBorderWidth:1.0f];
    selectCount.textAlignment=NSTextAlignmentCenter;
    [selectCount setTextColor:[UIColor whiteColor]];
    [selectCount setFont:[UIFont systemFontOfSize:11.0f]];
    selectCount.hidden=YES;
    [selectCount.layer setCornerRadius:8.0f];
    selectCount.clipsToBounds=YES;
    [btn addSubview:selectCount];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithCustomView:[self creatbtn:@"完成" withFrame:CGRectMake(10, 5, 50, 30) withAction:@selector(select_Compeleted)]];
    UIBarButtonItem* fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:@[leftItem,fixedSpace,rightItem] animated:YES];
    [self.view addSubview:toolBar];
    
    [self getImgsWithGroup:assetGroup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) preView_Action{

}
-(void) select_Compeleted{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RETURN_IMAGE_SELECT" object:nil userInfo:@{@"images":selectImages}];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 83.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowcount=(dataSource.count%4)>0?(dataSource.count/4+1):dataSource.count/4;
    return rowcount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"cell";
    PhotoCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell=[[NSBundle mainBundle] loadNibNamed:@"PhotoCell" owner:self options:nil][0];
    }
    if(dataSource.count>indexPath.row*4){
        cell.image1.image=dataSource[indexPath.row*4][@"image"];
        cell.image1.tag=indexPath.row*4;
        [cell.image1.gestureRecognizers[0] setEnabled:YES];
        if([dataSource[indexPath.row*4][@"selected"] boolValue]){
            cell.selected1.hidden=NO;
        }else{
            cell.selected1.hidden=YES;
        }
    }
    if(dataSource.count>indexPath.row*4+1) {
        cell.image2.image=dataSource[indexPath.row*4+1][@"image"];
        cell.image2.tag=indexPath.row*4+1;
        [cell.image2.gestureRecognizers[0] setEnabled:YES];
        if([dataSource[indexPath.row*4+1][@"selected"] boolValue]){
            cell.selected2.hidden=NO;
        }else{
            cell.selected2.hidden=YES;
        }
    }
    if(dataSource.count>indexPath.row*4+2){
        cell.image3.image=dataSource[indexPath.row*4+2][@"image"];
        cell.image3.tag=indexPath.row*4+2;
        [cell.image3.gestureRecognizers[0] setEnabled:YES];
        if([dataSource[indexPath.row*4+2][@"selected"] boolValue]){
            cell.selected3.hidden=NO;
        }else{
            cell.selected3.hidden=YES;
        }
    }
    if(dataSource.count>indexPath.row*4+3){
        cell.image4.image=dataSource[indexPath.row*4+3][@"image"];
        cell.image4.tag=indexPath.row*4+3;
        [cell.image4.gestureRecognizers[0] setEnabled:YES];
        if([dataSource[indexPath.row*4+3][@"selected"] boolValue]){
            cell.selected4.hidden=NO;
        }else{
            cell.selected4.hidden=YES;
        }
    }
    cell.indexPath=indexPath;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    cell.delegate=self;
    return cell;
}

//选中image之后的回调方法
-(void) imagecellSelected:(PhotoCell *)cell andImgTag:(NSInteger)tag andIndexPath:(NSIndexPath *)indexPath{
    [self caculateSelectImage:tag andIndexPath:indexPath];
}
-(void) caculateSelectImage:(NSInteger) index andIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *mdic=[dataSource[index] mutableCopy];
    if([mdic[@"selected"] boolValue]){
        [mdic setValue:@"NO" forKey:@"selected"];
        [selectImages removeObject:mdic[@"image"]];
        
    }else{
        if(selectImages.count<MAXIMAGE){
            [mdic setValue:@"YES" forKey:@"selected"];
            [selectImages addObject:mdic[@"image"]];
        }else{
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"最多只能选择%d张图片",MAXIMAGE] delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    if(selectImages.count>0){
        selectCount.hidden=NO;
        selectCount.text=[NSString stringWithFormat:@"%lu",selectImages.count];
    }else{
        selectCount.hidden=YES;
    }
    [dataSource setObject:mdic atIndexedSubscript:index];
    [self.maintableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}
-(void)getImgsWithGroup:(ALAssetsGroup *) ptotoGroup{
    /**
     *  根据相册组。获取每组的图片
     *
     *  @param result 含有每张照片的信息
     *  @param index  当前遍历的下标
     *  @param stop   是否停止遍历
     *
     *  @return
     */
    [ptotoGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                NSDictionary *dic=@{@"image":[UIImage imageWithCGImage:result.thumbnail],@"selected":@"NO"};
                [dataSource addObject:dic];
            }
        }
    }];
    [self.maintableview reloadData];
}
-(UIButton *) creatbtn:(NSString *)title withFrame:(CGRect) rect withAction:(SEL)action{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setFrame:rect];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [btn setBackgroundColor:[UIColor colorWithRed:0/255.0 green:127/255.0 blue:245/255.0 alpha:1.0f]];
    [btn.layer setCornerRadius:3.0f];
    return btn;
}
@end
