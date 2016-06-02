//
//  PickChinaCityController.m
//  城市选择Demo
//
//  Created by Kenfor-YF on 16/5/30.
//  Copyright © 2016年 Kenfor-YF. All rights reserved.
//

#import "PickChinaCityController.h"
#import "CityIndexCell.h"
#import "sectionHeadView.h"
#import "HotCityCell.h"
#import "LocationCityCell.h"
#import "YLYTableViewIndexView.h"
#import "Masonry.h"
#define XMWidth ([UIScreen mainScreen].bounds.size.width)
#define XMHeight ([UIScreen mainScreen].bounds.size.height)
@interface PickChinaCityController ()<UITableViewDataSource,UITableViewDelegate,YLYTableViewIndexViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *twoCityArray;
@property(nonatomic,strong)NSArray *sessionArray;
@property(nonatomic,strong)NSArray *indexArray;
@property(nonatomic,strong)NSDictionary *cityDict;
@property(nonatomic,strong)UILabel *flotageLabel;

@end

@implementation PickChinaCityController
-(NSDictionary *)cityDict
{
    if (!_cityDict) {
        NSString *inlangPlist = [[NSBundle mainBundle]pathForResource:@"inLandCityGroup.plist" ofType:nil];
        _cityDict = [NSDictionary dictionaryWithContentsOfFile:inlangPlist];
    }
    return _cityDict;
}
-(NSArray *)sessionArray
{
    if (!_sessionArray) {
//        _sessionArray = [NSArray array];
        NSString *inlangPlist = [[NSBundle mainBundle]pathForResource:@"inLandCityGroup.plist" ofType:nil];
        NSDictionary *cityDict = [NSDictionary dictionaryWithContentsOfFile:inlangPlist];
        NSArray *array = [cityDict allKeys];
        //对该地区元素进行升序排序
        _sessionArray = [array sortedArrayUsingSelector:@selector(compare:)];
    }
    return _sessionArray;
}
-(NSMutableArray *)twoCityArray
{
    if (!_twoCityArray) {
        _twoCityArray = [NSMutableArray array];
    }
    return _twoCityArray;
}
-(NSArray *)indexArray
{
    if (!_indexArray) {
        _indexArray = [NSArray array];
        NSString *inlangPlist = [[NSBundle mainBundle]pathForResource:@"inLandCityGroup.plist" ofType:nil];
        NSDictionary *cityDict = [NSDictionary dictionaryWithContentsOfFile:inlangPlist];
        _indexArray = [cityDict allValues];
    }
    return _indexArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithTableView];
    [self getRequestChinaData];
    [self initIndexView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cityButtonClick:) name:@"keyCityBtnClick" object:nil];
}
-(void)cityButtonClick:(NSNotification *)noti
{
    NSString *info = noti.userInfo[@"keyCityBtnClick"];
    if (info) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
-(void)initIndexView
{
    self.flotageLabel = [[UILabel alloc]init];
    self.flotageLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"flotageBackgroud"]];
    self.flotageLabel.hidden = YES;
    self.flotageLabel.textAlignment = NSTextAlignmentCenter;
    self.flotageLabel.textColor  = [UIColor whiteColor];
    [self.view addSubview:self.flotageLabel];
    [self.flotageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(64, 64));
    }];
    
    
    YLYTableViewIndexView *indexView = [[YLYTableViewIndexView alloc]initWithFrame:CGRectMake(XMWidth - 20, 0, 20, XMHeight)];
    indexView.tableIndexDelegate = self;
    [self.view addSubview:indexView];    
    CGRect rect = indexView.frame;
    rect.size.height = self.sessionArray.count * 16;
    rect.origin.y = (XMHeight - 64 - rect.size.height) / 2;
    indexView.frame = rect;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
-(void)initWithTableView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, XMWidth, XMHeight - 64)];
    self.tableView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
}
-(void)getRequestChinaData
{
    [self.twoCityArray addObjectsFromArray:@[@"当前城市",@"热门城市"]];
}
#pragma mark -UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sessionArray.count + 2;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    sectionHeadView *headView = [[sectionHeadView alloc]init];
    if (section <= 1) {
        headView.title = [self.twoCityArray objectAtIndex:section];
    }else {
        headView.title = [self.sessionArray objectAtIndex:section - 2];
    }
    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section <= 1) {
        return 1;
    }else{
        NSString *key = [self.sessionArray objectAtIndex:section - 2];
        NSArray *array = [self.cityDict objectForKey:key];
        return array.count;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        LocationCityCell *cell = [LocationCityCell cellWithTableView:tableView];
        return cell;
    } else if (indexPath.section == 1){
        HotCityCell *cell = [HotCityCell cellWithTableView:tableView];
        return cell;
    }else {
        CityIndexCell *cell = [CityIndexCell cellWithTableView:tableView];
        NSString *key = [self.sessionArray objectAtIndex:indexPath.section - 2];
        NSArray *array = [self.cityDict valueForKey:key];
        NSDictionary *dict = [array objectAtIndex:indexPath.row];
        //拿到它的key值(通过遍历方法)
        NSEnumerator *enumeratorKey = [dict keyEnumerator];
        cell.cityName = [enumeratorKey nextObject];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section <= 1) {
        
    }else{
        NSString *key = [self.sessionArray objectAtIndex:indexPath.section - 2];
        NSArray *array = [self.cityDict valueForKey:key];
        NSDictionary *dict = [array objectAtIndex:indexPath.row];
        NSEnumerator *enumKey = [dict keyEnumerator];
        NSString *objectKey = [enumKey nextObject];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"keyCityBtnClick" object:nil userInfo:@{@"keyCityBtnClick":objectKey}];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 56;
    }else if (indexPath.section == 1){
        return 260;
    }else{
        return 50;
    }
}
#pragma mark -YLYTableViewIndexViewDelegate
-(void)tableViewIndex:(YLYTableViewIndexView *)tableIndexView didSelectedAtIndex:(NSInteger)index withTitle:(NSString *)title
{
    if ([self.tableView numberOfSections] > index && index > -1) {
        //移动到第几行的第一个cell前面.
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index + 2] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        self.flotageLabel.text = title;
        
    }
}
-(void)tableViewIndexTouchBegan:(YLYTableViewIndexView *)tableIndexView
{
    self.flotageLabel.hidden = NO;
}
-(void)tableViewIndexTouchEnd:(YLYTableViewIndexView *)tableIndexView
{
    CATransition *anim = [CATransition animation];
    anim.type = kCATransitionFade;
    anim.duration = 0.4;
    [self.flotageLabel.layer addAnimation:anim forKey:nil];
    self.flotageLabel.hidden = YES;
}















-(NSArray *)tableViewIndexTitle:(YLYTableViewIndexView *)tableIndexView
{
    return self.sessionArray;
}
@end
