//
//  AlbumPhotosListView.h
//  SimpleCollectionViewAPI
//
//  Created by Simple Shi on 7/18/14.
//  Copyright (c) 2014 Microthink Inc,. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface AlbumPhotosListView : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *selectImages;
@property (nonatomic, strong) UITableView *maintableview;
@property (nonatomic, strong) ALAssetsGroup *assetGroup;
@end
