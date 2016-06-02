//
//  BaseViewController.m
//  城市选择Demo
//
//  Created by Kenfor-YF on 16/5/30.
//  Copyright © 2016年 Kenfor-YF. All rights reserved.
//

#import "BaseViewController.h"
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue]>=7.0)
@interface BaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置iOS7之后不会上移
    if (iOS7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self creatLeftBtn];
    
}
-(void)creatLeftBtn
{
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30);
    UIImage *image = [UIImage imageNamed:@"nav_arrow"];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setBackgroundImage:image forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    btn.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //设置它的宽度
    negativeSpacer.width = -20;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,buttonItem];
}
-(void)btnClick
{
    if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

@end
