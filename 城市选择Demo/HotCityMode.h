//
//  HotCityMode.h
//  城市选择Demo
//
//  Created by Kenfor-YF on 16/5/31.
//  Copyright © 2016年 Kenfor-YF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotCityMode : NSObject
@property(nonatomic,copy)NSString *habitable;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *parent;
@property(nonatomic,copy)NSString *uid;
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
