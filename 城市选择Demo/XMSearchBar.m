//
//  XMSearchBar.m
//  城市选择Demo
//
//  Created by Kenfor-YF on 16/5/31.
//  Copyright © 2016年 Kenfor-YF. All rights reserved.
//

#import "XMSearchBar.h"

@implementation XMSearchBar
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.placeholder = @"输入城市名查询";
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textAlignment = NSTextAlignmentLeft;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        //放大镜图片显示
        self.leftViewMode = UITextFieldViewModeAlways;
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"searchbar_textfield_search_icon"]];
        imageView.frame = CGRectMake(0, 0, 30, 30);
        imageView.contentMode = UIViewContentModeCenter;
        self.leftView = imageView;
        self.font = [UIFont systemFontOfSize:15.0];
        
    }
    return self;
}


@end
