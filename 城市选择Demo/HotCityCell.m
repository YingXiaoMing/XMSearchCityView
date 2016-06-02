//
//  HotCityCell.m
//  城市选择Demo
//
//  Created by Kenfor-YF on 16/5/31.
//  Copyright © 2016年 Kenfor-YF. All rights reserved.
//

#import "HotCityCell.h"
#import "HotCityMode.h"
#define XMWidth ([UIScreen mainScreen].bounds.size.width)

@interface HotCityCell()
@property(nonatomic,strong)NSMutableArray *hotCityArray;
@end
@implementation HotCityCell
-(NSMutableArray *)hotCityArray
{
    if (!_hotCityArray) {
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"hotcityCode.plist" ofType:nil];
        NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
        NSMutableArray *dictArray = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            HotCityMode *mode = [[HotCityMode alloc]initWithDict:dict];
            [dictArray addObject:mode];
        }
        self.hotCityArray = dictArray;
    }
    return _hotCityArray;
}
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellIdentify = @"hotCityCell";
    HotCityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[HotCityCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentify];
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
        [self initUI];
    }
    return self;
}
-(void)initUI
{
    CGFloat padding = 15;
    CGFloat btnH = 36;
    CGFloat btnW = 90;
    CGFloat boardPadding = (XMWidth - 3 * btnW - 30)/2;
    for (int i = 0;i <= 14; i++) {
        HotCityMode *mode = self.hotCityArray[i];
        UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        locationBtn.layer.cornerRadius = 5;
        locationBtn.tag = i;
        locationBtn.layer.borderWidth = 0.4;
        locationBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        locationBtn.backgroundColor = [UIColor whiteColor];
        locationBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [locationBtn setTitle:mode.name forState:UIControlStateNormal];
        [locationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [locationBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:locationBtn];
        locationBtn.frame = CGRectMake((boardPadding + btnW)*(i%3) + padding, (padding + btnH)*(i/3) + padding, btnW, btnH);
    }
}
-(void)btnClick:(UIButton *)sender
{
    NSString *objectKey = [sender titleForState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"keyCityBtnClick" object:nil userInfo:@{@"keyCityBtnClick":objectKey}];
}
@end
