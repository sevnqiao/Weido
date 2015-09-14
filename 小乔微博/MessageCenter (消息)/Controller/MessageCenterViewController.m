//
//  MessageCenterViewController.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/2.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "Test1ViewController.h"
#import "WhisperViewController.h"
#import "HttpTool.h"

@interface MessageCenterViewController ()

@end

@implementation MessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"写私信" style:UIBarButtonItemStylePlain target:self action:@selector(edit)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
//
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//
}

- (void)edit{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * ID = @"mseeageCenter";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
//    cell.textLabel.text = [NSString stringWithFormat:@"测试数据-- %ld",(long)indexPath.row];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"我的评论";
    }
    
    return cell;
}

#pragma mark - 代理

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        WhisperViewController * Wvc = [[WhisperViewController alloc]init];
        [self.navigationController pushViewController:Wvc animated:YES];
    }
    else
    {
        Test1ViewController * test1 = [[Test1ViewController alloc]init];
        [self.navigationController pushViewController:test1 animated:YES];
    }
}

@end
