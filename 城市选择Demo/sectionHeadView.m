//
//  sectionHeadView.m
//  城市选择Demo
//
//  Created by Kenfor-YF on 16/5/30.
//  Copyright © 2016年 Kenfor-YF. All rights reserved.
//

#import "sectionHeadView.h"
#define XMWidth ([UIScreen mainScreen].bounds.size.width)
@interface sectionHeadView()
@property(nonatomic,strong)UILabel *headerLabel;

@end
@implementation sectionHeadView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, XMWidth, 25);
        self.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
        [self setUI];
    }
    return self;
}
-(void)setUI
{
    self.headerLabel = [[UILabel alloc]init];
    self.headerLabel.frame = CGRectMake(15, 0, 200, 25);
    self.headerLabel.textColor = [UIColor grayColor];
    self.headerLabel.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:self.headerLabel];
}
-(void)setTitle:(NSString *)title
{
    _title = title;
    self.headerLabel.text = title;
}
@end
