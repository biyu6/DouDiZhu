//
//  ViewController.m
//  BYDouDiZhu
//
//  Created by 胡忠诚 on 2018/4/16.
//  Copyright © 2018年 biyu6. All rights reserved.
//

#import "ViewController.h"
#import "BYEasyVC.h"
#import "BYTestTwoVC.h"

@interface ViewController ()

@end
@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(10, 100, 200, 50)];
    btn1.backgroundColor = [UIColor redColor];
    [btn1 setTitle:@"最简单的演示" forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    [btn1 addTarget:self action:@selector(clickToOne) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(10, 160, 200, 50)];
    btn2.backgroundColor = [UIColor redColor];
    [btn2 setTitle:@"测试" forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    [btn2 addTarget:self action:@selector(clickToTwo) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)clickToOne{
    BYEasyVC *easyVC = [[BYEasyVC alloc]init];
    [self presentViewController:easyVC animated:YES completion:nil];
}
- (void)clickToTwo{
    BYTestTwoVC *testTwoVC = [[BYTestTwoVC alloc]init];
    [self presentViewController:testTwoVC animated:YES completion:nil];
}


@end
