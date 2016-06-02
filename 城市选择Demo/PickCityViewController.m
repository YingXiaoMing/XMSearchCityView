//
//  PickCityViewController.m
//  城市选择Demo
//
//  Created by Kenfor-YF on 16/5/30.
//  Copyright © 2016年 Kenfor-YF. All rights reserved.
//

#import "PickCityViewController.h"
#import "PickChinaCityController.h"
#import "SearchCityViewController.h"
#import "PickOverseaViewController.h"
#define XMWidth ([UIScreen mainScreen].bounds.size.width)
#define XMHeight ([UIScreen mainScreen].bounds.size.height)
#define SearchBarHeight 44.f
@interface PickCityViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UISegmentedControl *segmentedControl;
@property(nonatomic,strong)NSMutableArray *viewControllers;
@property(nonatomic,strong)PickChinaCityController *chinaVc;
@property(nonatomic,strong)PickOverseaViewController *overseaVc;
@property(nonatomic,strong)UIScrollView *backgroundScrollView;


@end

@implementation PickCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置titleView
    [self loadSegementControl];
    //添加控制器
    [self addControllers];
    //添加底部scrollView
    [self addBackgroundScrollView];
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, XMWidth, SearchBarHeight)];
    searchBar.placeholder = @"输入城市名查询";
    searchBar.userInteractionEnabled = YES;
    searchBar.backgroundImage = [UIImage imageNamed:@"searchBarBackImage"];
    UITextField *txtSearchFile = [searchBar valueForKey:@"_searchField"];
    txtSearchFile.backgroundColor = [UIColor colorWithRed:244/250.0 green:244/250.0 blue:244/250.0 alpha:1.0];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, XMWidth, SearchBarHeight);
    [btn addTarget:self action:@selector(pushSearchViewControl) forControlEvents:UIControlEventTouchUpInside];
    [searchBar addSubview:btn];
    
    [self.view addSubview:searchBar];
}
-(void)pushSearchViewControl
{
    SearchCityViewController *searchVC = [[SearchCityViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:searchVC];
    //设置转场动画
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)loadSegementControl
{
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *segmentArray = [[NSArray alloc]initWithObjects:@"国内",@"国外", nil];
    _segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentArray];
    _segmentedControl.frame = CGRectMake(0, 0, 180, 30);
    _segmentedControl.tintColor = [UIColor colorWithRed:(63 / 255.0) green:(184 / 255.0) blue:(56 / 255.0) alpha:1];
    [_segmentedControl setSelectedSegmentIndex:0];
    [_segmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmentedControl;
}
-(void)segmentedControlAction:(id)sender
{
    NSInteger selectedIndex = [sender selectedSegmentIndex];
    [self.backgroundScrollView setContentOffset:CGPointMake(selectedIndex * XMWidth, 0) animated:NO];
    
}
-(void)addControllers
{
    self.chinaVc = [[PickChinaCityController alloc]init];
    self.overseaVc = [[PickOverseaViewController alloc]init];
    [self addChildViewController:self.chinaVc];
    [self addChildViewController:self.self.overseaVc];
    self.viewControllers = [[NSMutableArray alloc]initWithObjects:self.chinaVc,self.overseaVc, nil];
}
-(void)addBackgroundScrollView
{
    NSInteger viewCounts = self.viewControllers.count;
    self.backgroundScrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.backgroundScrollView.pagingEnabled = YES;
    self.backgroundScrollView.bounces = NO;
    self.backgroundScrollView.showsHorizontalScrollIndicator = NO;
    self.backgroundScrollView.showsVerticalScrollIndicator = NO;
    self.backgroundScrollView.delegate = self;
    self.backgroundScrollView.contentSize = CGSizeMake(viewCounts * XMWidth, 0);
    [self.view addSubview:self.backgroundScrollView];
    for (int i = 0; i < viewCounts; i++) {
        UIViewController *VC = self.viewControllers[i];
        VC.view.frame = CGRectMake(XMWidth * i, 64 + 44, XMWidth, XMHeight);
        [self.backgroundScrollView addSubview:VC.view];
    }
    [self.backgroundScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    
}
#pragma mark -UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageIndex = scrollView.contentOffset.x / XMWidth;
    [self.segmentedControl setSelectedSegmentIndex:pageIndex];
}










































@end
