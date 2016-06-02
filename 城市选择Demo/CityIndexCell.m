//
//  CityIndexCell.m
//  城市选择Demo
//
//  Created by Kenfor-YF on 16/5/30.
//  Copyright © 2016年 Kenfor-YF. All rights reserved.
//

#import "CityIndexCell.h"
#import "Masonry.h"
#define XMWidth ([UIScreen mainScreen].bounds.size.width)
@interface CityIndexCell()
@property(nonatomic,strong)UILabel *cityIndexLabel;
@property(nonatomic,strong)UIView *lineView;
@end
@implementation CityIndexCell
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CityCell";
    CityIndexCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CityIndexCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.cityIndexLabel = [[UILabel alloc]init];
        self.cityIndexLabel.backgroundColor = [UIColor clearColor];
        self.cityIndexLabel.textColor = [UIColor blackColor];
        self.cityIndexLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.contentView addSubview:self.cityIndexLabel];
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        [self.contentView addSubview:self.lineView];
        [self.cityIndexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.top.equalTo(self.contentView).offset(15);
            make.height.mas_equalTo(@20);
            make.width.mas_equalTo(@(XMWidth - 30));
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@15);
            make.size.mas_equalTo(CGSizeMake(XMWidth - 15, 0.8));
            make.top.equalTo(self.contentView.mas_bottom).offset(-0.8);
        }];
    }
    return self;
}
-(void)setCityName:(NSString *)cityName
{
    _cityName = cityName;
    self.cityIndexLabel.text = cityName;
}

@end
