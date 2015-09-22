//
//  DiscoverViewController.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/2.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "DiscoverViewController.h"
#import "SearchBar.h"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UISearchBar * searchBar = [[UISearchBar alloc]init];
//    searchBar.scopeBarBackgroundImage = [UIImage imageNamed:@"searchbar_textfield_background"];
//    self.navigationItem.titleView = searchBar;
    
//    UITextField * searchBar = [[UITextField alloc]init];
//    searchBar.background = [[UIImage imageNamed:@"searchbar_textfield_background"]stretchableImageWithLeftCapWidth:1 topCapHeight:1];
//    searchBar.width = 300;
//    searchBar.height = 35;
//    
//    searchBar.font = [UIFont systemFontOfSize:14];
//    searchBar.placeholder = @"请输入搜索条件";
//    
//    // 设置左边放大镜图标
//    UIImageView * searchIcon = [[UIImageView alloc]init];
//    searchIcon.image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
//    searchIcon.contentMode = UIViewContentModeCenter;
//    searchIcon.height = 30;
//    searchIcon.width = 30;
//    
//    searchBar.leftView = searchIcon;
//    searchBar.leftViewMode = UITextFieldViewModeAlways;
    
     // 创建搜索框 ( 相当于上面代码)
    self.navigationItem.titleView = [SearchBar searchBar];
    self.tableView.backgroundColor = color(244,243,241);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
