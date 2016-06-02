//
//  ViewController.m
//  城市选择Demo
//
//  Created by Kenfor-YF on 16/5/30.
//  Copyright © 2016年 Kenfor-YF. All rights reserved.
//

#import "ViewController.h"
#import "PickCityViewController.h"
@interface ViewController ()
@property(nonatomic,strong)UIButton *titleBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"主页";
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleBtn setTitle:@"当前城市: 北京" forState:UIControlStateNormal];
    titleBtn.frame = CGRectMake(0, 0, 160, 40);
    titleBtn.center = self.view.center;
    [titleBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    titleBtn.backgroundColor = [UIColor grayColor];
    self.titleBtn = titleBtn;
    [self.view addSubview:titleBtn];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cityNameClick:) name:@"keyCityBtnClick" object:nil];
    
}
-(void)btnClick
{
    PickCityViewController *pickVC = [[PickCityViewController alloc]init];
    [self.navigationController pushViewController:pickVC animated:YES];
}
-(void)cityNameClick:(NSNotification *)noti
{
    NSString *cityName = noti.userInfo[@"keyCityBtnClick"];
    [self.titleBtn setTitle:cityName forState:UIControlStateNormal];
}

@end
