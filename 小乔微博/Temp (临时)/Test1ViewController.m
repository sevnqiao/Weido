//
//  Test1ViewController.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/2.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "Test1ViewController.h"

@interface Test1ViewController ()

@end

@implementation Test1ViewController
- (IBAction)back:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
