//
//  SearchCityViewController.m
//  城市选择Demo
//
//  Created by Kenfor-YF on 16/5/31.
//  Copyright © 2016年 Kenfor-YF. All rights reserved.
//

#import "SearchCityViewController.h"
#import "XMSearchBar.h"
#import "CityIndexCell.h"
#import <pinyin.h>

#define XMWidth ([UIScreen mainScreen].bounds.size.width)
#define XMHeight ([UIScreen mainScreen].bounds.size.height)
@interface SearchCityViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong)XMSearchBar *searchTF;
@property(nonatomic,strong)UIView *warningView;
@property(nonatomic,strong)NSMutableArray *resultArray;
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation SearchCityViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}
-(void)initWithTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, XMWidth, XMHeight) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self initWithTableView];
    [self initSearchBar];
    [self initWarningLabel];
    
}
-(void)initSearchBar
{
    CGFloat searchViewW = XMWidth;
    CGFloat searchViewH = 44;
    UIView *searchView = [[UIView alloc]init];
    searchView.backgroundColor = [UIColor clearColor];
    searchView.frame = CGRectMake(0, 0, searchViewW, searchViewH);
    CGFloat searchBarW = XMWidth - 60;
    CGFloat searchBarH = 32;
    CGFloat searchBarX = 5;
    self.searchTF = [[XMSearchBar alloc]init];
    self.searchTF.keyboardType = UIKeyboardTypeWebSearch;
    self.searchTF.layer.borderWidth = 0.2;
    self.searchTF.layer.cornerRadius = 4;
    
    self.searchTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.searchTF.backgroundColor = [UIColor colorWithRed:244/250.0 green:244/250.0 blue:244/250.0 alpha:1.0];
    self.searchTF.frame = CGRectMake(0, searchBarX, searchBarW, searchBarH);
    [self.searchTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [searchView addSubview:self.searchTF];
    CGFloat cancelBtnX = XMWidth - 65;
    CGFloat cancelBtnW = 60;
    CGFloat cancelBtnH = searchBarH;
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(cancelBtnX, searchBarX, cancelBtnW, cancelBtnH);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:[UIColor colorWithRed:63/255.0 green:184/250.0 blue:56/250.0 alpha:1.0] forState:UIControlStateNormal];
    [searchView addSubview:cancelBtn];
    self.navigationItem.titleView = searchView;
    self.navigationItem.leftBarButtonItem = nil;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.searchTF becomeFirstResponder];
}
-(void)initWarningLabel
{
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    bgView.backgroundColor = [UIColor whiteColor];
    UILabel *warningL = [[UILabel alloc]initWithFrame:CGRectMake((XMWidth - 100)/2, (XMHeight - 40)/2, 100, 40)];
    warningL.text = @"无结果";
    warningL.font = [UIFont systemFontOfSize:25];
    warningL.textColor = [UIColor grayColor];
    [bgView addSubview:warningL];
    [self.view addSubview:bgView];
    self.warningView = bgView;
    self.warningView.hidden = YES;
    
}
-(void)textFieldDidChange:(UITextField *)textfile
{
    [self SearchCityWithMatching:textfile.text];
}
-(void)cancelBtnClick
{
    CATransition *anim = [CATransition animation];
    anim.duration = 0.5;
    anim.type = kCATransitionFade;
    anim.timingFunction = UIViewAnimationCurveEaseInOut;
    [self.view.window.layer addAnimation:anim forKey:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CityIndexCell *cell = [CityIndexCell cellWithTableView:tableView];
    cell.cityName = self.resultArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *objectKey = self.resultArray[indexPath.row];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"keyCityBtnClick" object:nil userInfo:@{@"keyCityBtnClick":objectKey}];
    [self cancelBtnClick];
    
}
#pragma mark - 匹配关键字
-(void)SearchCityWithMatching:(NSString *)searchText
{
    self.resultArray = [NSMutableArray array];
    if (searchText.length > 0 && [self isIncludeChineseString:searchText]) {//中文
        NSArray *nameArr = [self getAllCityName];
        //遍历它每一个字段,匹配它的字段是否符合要求
        for (NSString *cName in nameArr) {
            NSRange titleResult = [cName rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (titleResult.length > 0) {
                [self.resultArray addObject:cName];
            }
        }
    }else if (searchText.length > 0 && ![self isIncludeChineseString:searchText]) {//英文
        NSArray *nameArr = [self getAllCityName];
        for (NSString *cName in nameArr) {
            if ([self isIncludeChineseString:cName]) {//是否是中文,如果是的话,搜索到中文的首字母
               
                NSString *tmpStr = cName.firstLetters;
                NSLog(@"%@",tmpStr);
                
                NSRange titleResult = [tmpStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleResult.length > 0 ) {
                    [self.resultArray addObject:cName];
                }
            }else{//英文
                NSRange titleResult = [cName rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleResult.length > 0) {
                    [self.resultArray addObject:cName];
                }
            }
        }
    }
    if (self.resultArray.count > 0) {
        self.warningView.hidden = YES;
    }else {
        self.warningView.hidden = NO;
    }
    [self.tableView reloadData];
}
-(void)backToCityNameHead:(NSString *)searchText
{
    
}
//里面是否有中文
-(BOOL)isIncludeChineseString:(NSString *)searchText
{
    for (int i=0; i<searchText.length; i++) {
        unichar ch = [searchText characterAtIndex:i];
        if (0x4e00 < ch && ch < 0x9fff) {
            return true;
        }
    }
    return false;
}
-(NSArray *)getAllCityName
{
    NSString *allCityName = [[NSBundle mainBundle]pathForResource:@"AllCityName" ofType:nil];
    NSError *error = nil;
    NSString *name = [[NSString alloc]initWithContentsOfFile:allCityName encoding:NSUTF8StringEncoding error:&error];
    NSArray *cityNameArray = [name componentsSeparatedByString:@"city="];
    return cityNameArray;
}
@end
