//
//  LocationCityCell.m
//  城市选择Demo
//
//  Created by Kenfor-YF on 16/5/30.
//  Copyright © 2016年 Kenfor-YF. All rights reserved.
//

#import "LocationCityCell.h"
#import "Masonry.h"
#import "LocationManager.h"
@interface LocationCityCell()
@property(nonatomic,strong)UIButton *locationBtn;

@end

@implementation LocationCityCell
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"LocationCell";
    LocationCityCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[LocationCityCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
        [self initUI];
        LocationManager *mgr = [LocationManager sharedOfLocation];
        [mgr getCurrentLocation:^(CLLocation *currentLocation, NSString *cityName) {
            [self.locationBtn setTitle:cityName forState:UIControlStateNormal];
            self.locationBtn.enabled = YES;
        }];
    }
    return self;
}
-(void)initUI
{
    self.locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.locationBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.locationBtn.layer.borderWidth = 0.4;
    self.locationBtn.layer.cornerRadius = 5;
    self.locationBtn.backgroundColor = [UIColor whiteColor];
    [self.locationBtn setTitle:@"定位中" forState:UIControlStateNormal];
    self.locationBtn.enabled = NO;
    [self.locationBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.locationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.locationBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
    [self.locationBtn setImage:[UIImage imageNamed:@"AlbumLocationIconHL"] forState:UIControlStateNormal];
    self.locationBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:self.locationBtn];
    [self.locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(100, 36));
    }];
}
-(void)btnClick:(UIButton *)sender
{
    NSString *objectKey = [sender titleForState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"keyCityBtnClick" object:nil userInfo:@{@"keyCityBtnClick":objectKey}];
}
@end
