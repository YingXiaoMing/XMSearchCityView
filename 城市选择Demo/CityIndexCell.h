//
//  CityIndexCell.h
//  城市选择Demo
//
//  Created by Kenfor-YF on 16/5/30.
//  Copyright © 2016年 Kenfor-YF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityIndexCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic,copy)NSString *cityName;

@end
