//
//  PickOverseaViewController.m
//  城市选择Demo
//
//  Created by Kenfor-YF on 16/6/1.
//  Copyright © 2016年 Kenfor-YF. All rights reserved.
//

#import "PickOverseaViewController.h"
#import "Masonry.h"
#import "CityIndexCell.h"
#import "sectionHeadView.h"
#import "YLYTableViewIndexView.h"
#define XMWidth ([UIScreen mainScreen].bounds.size.width)
#define XMHeight ([UIScreen mainScreen].bounds.size.height)
@interface PickOverseaViewController ()<UITableViewDelegate,UITableViewDataSource,YLYTableViewIndexViewDelegate>
@property(nonatomic,strong)NSDictionary *cityDict;
@property(nonatomic,strong)NSArray *sessionArray;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UILabel *flotaLabel;
@end

@implementation PickOverseaViewController
-(NSDictionary *)cityDict
{
    if (!_cityDict) {
        NSString *outlandPlist = [[NSBundle mainBundle]pathForResource:@"outLandCityGroup.plist" ofType:nil];
        _cityDict = [NSDictionary dictionaryWithContentsOfFile:outlandPlist];
    }
    return _cityDict;
}
-(NSArray *)sessionArray
{
    if (!_sessionArray) {
        NSString *outlandPlist = [[NSBundle mainBundle]pathForResource:@"outLandCityGroup.plist" ofType:nil];
        NSDictionary *cityDict = [NSDictionary dictionaryWithContentsOfFile:outlandPlist];
        NSArray *array = [cityDict allKeys];
        _sessionArray = [array sortedArrayUsingSelector:@selector(compare:)];
    }
    return _sessionArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithTableView];
    [self initWithIndexView];
}
-(void)initWithIndexView
{
    self.flotaLabel = [[UILabel alloc]init];
    self.flotaLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"flotageBackgroud"]];
    self.flotaLabel.hidden = YES;
    self.flotaLabel.textAlignment = NSTextAlignmentCenter;
    self.flotaLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.flotaLabel];
    [self.flotaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(64, 64));
    }];
    //indexView
    YLYTableViewIndexView *indexView = [[YLYTableViewIndexView alloc]initWithFrame:CGRectMake(XMWidth - 20, 0, 20, XMHeight)];
    indexView.tableIndexDelegate = self;
    [self.view addSubview:indexView];
    CGRect rect = indexView.frame;
    rect.size.height = self.sessionArray.count * 16;
    rect.origin.y = (XMHeight - 64 - rect.size.height)/2;
    indexView.frame = rect;
}
-(void)initWithTableView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,XMWidth , XMHeight - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:244/250.0 green:244/250.0 blue:244/250.0 alpha:1.0];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sessionArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [self.sessionArray objectAtIndex:section];
    NSArray *array = [self.cityDict objectForKey:key];
    return array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CityIndexCell *cell = [CityIndexCell cellWithTableView:tableView];
    NSString *key = [self.sessionArray objectAtIndex:indexPath.section];
    NSArray *array = [self.cityDict objectForKey:key];
    NSDictionary *dict = [array objectAtIndex:indexPath.row];
    //取到它的key值
    NSEnumerator *enumkey = [dict keyEnumerator];
    cell.cityName = [enumkey nextObject];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    sectionHeadView *headView = [[sectionHeadView alloc]init];
    headView.title = [self.sessionArray objectAtIndex:section];
    return headView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *key = [self.sessionArray objectAtIndex:indexPath.section];
    NSArray *array = [self.cityDict objectForKey:key];
    NSDictionary *dict = [array objectAtIndex:indexPath.row];
    NSEnumerator *enumkey = [dict keyEnumerator];
    NSString *objectKey = [enumkey nextObject];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"keyCityBtnClick" object:nil userInfo:@{@"keyCityBtnClick":objectKey}];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark -YLYTableViewIndexViewDelegate
-(NSArray *)tableViewIndexTitle:(YLYTableViewIndexView *)tableIndexView
{
    return self.sessionArray;
}
-(void)tableViewIndex:(YLYTableViewIndexView *)tableIndexView didSelectedAtIndex:(NSInteger)index withTitle:(NSString *)title
{
    if ([self.tableView numberOfSections] > index && index > -1) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        self.flotaLabel.text = title;
    }
}
-(void)tableViewIndexTouchBegan:(YLYTableViewIndexView *)tableIndexView
{
    self.flotaLabel.hidden = NO;
}
-(void)tableViewIndexTouchEnd:(YLYTableViewIndexView *)tableIndexView
{
    CATransition *anim = [CATransition animation];
    anim.type = kCATransitionFade;
    anim.duration = 0.4;
    [self.flotaLabel.layer addAnimation:anim forKey:nil];
    self.flotaLabel.hidden = YES;
}
@end
