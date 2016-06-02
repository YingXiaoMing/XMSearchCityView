//
//  YLYTableViewIndexView.h
//  城市选择Demo
//
//  Created by Kenfor-YF on 16/5/31.
//  Copyright © 2016年 Kenfor-YF. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YLYTableViewIndexView;
@protocol YLYTableViewIndexViewDelegate <NSObject>
//得到右边索引条的title数组
-(NSArray *)tableViewIndexTitle:(YLYTableViewIndexView *)tableIndexView;
//开始触摸索引
-(void)tableViewIndexTouchBegan:(YLYTableViewIndexView *)tableIndexView;
//结束触摸索引
-(void)tableViewIndexTouchEnd:(YLYTableViewIndexView *)tableIndexView;
//移动到某一个指定的位置上.
-(void)tableViewIndex:(YLYTableViewIndexView *)tableIndexView didSelectedAtIndex:(NSInteger)index withTitle:(NSString *)title;

@end
@interface YLYTableViewIndexView : UIView
@property(nonatomic,weak)id<YLYTableViewIndexViewDelegate> tableIndexDelegate;

@end
