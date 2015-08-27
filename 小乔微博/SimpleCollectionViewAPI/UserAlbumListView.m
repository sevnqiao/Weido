//
//  UserAlbumListView.m
//  SimpleCollectionViewAPI
//
//  Created by Simple Shi on 7/18/14.
//  Copyright (c) 2014 Microthink Inc,. All rights reserved.
//

#import "UserAlbumListView.h"
#import "AlbumPhotosListView.h"
#import "AlbumCell.h"

@interface UserAlbumListView ()
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) AlbumPhotosListView *photolistview;
@end

@implementation UserAlbumListView
@synthesize assetsLibrary,photolistview;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"相册";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel:)];
    _dataSource=[NSMutableArray array];
    [self loadAlbums];
    
}
-(void) cancel:(id) sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 83;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"cell";
    AlbumCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell=[[NSBundle mainBundle] loadNibNamed:@"AlbumCell" owner:self options:nil][0];
    }
    ALAssetsGroup *group=_dataSource[indexPath.row];
    [cell setcontent:group];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ALAssetsGroup *group=_dataSource[indexPath.row];
    photolistview=[[AlbumPhotosListView alloc] init];
    photolistview.assetGroup=_dataSource[indexPath.row];
    photolistview.title=[self getAlbumName:[group valueForProperty:ALAssetsGroupPropertyName]];
    [self.navigationController pushViewController:photolistview animated:YES];
}
//加载相册
-(void) loadAlbums{
    assetsLibrary=[[ALAssetsLibrary alloc] init];
    
    void (^assetsGroupsEnumerationBlock)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *assetsGroup, BOOL *stop) {
        [assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
        if(assetsGroup.numberOfAssets > 0) {
            [self.dataSource addObject:assetsGroup];
            [self.tableView reloadData];
        }
    };
    
    void (^assetsGroupsFailureBlock)(NSError *) = ^(NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    };
    // Enumerate Camera Roll
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Photo Stream
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupPhotoStream usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Album
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Event
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupEvent usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Faces
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupFaces usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
}

-(NSString *) getAlbumName:(NSString *) albumName{
    NSString *name=@"";
    if([albumName isEqualToString:@"My Photo Stream"]){
        name=@"我的照片流";
    }else if([albumName isEqualToString:@"Camera Roll"]){
        name=@"相机照片";
    }else{
        name=albumName;
    }
    return name;
}
@end
