//
//  HotCityMode.m
//  城市选择Demo
//
//  Created by Kenfor-YF on 16/5/31.
//  Copyright © 2016年 Kenfor-YF. All rights reserved.
//

#import "HotCityMode.h"

@implementation HotCityMode
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        if (dict[@"id"]) {
            self.ID = [NSString stringWithFormat:@"%@",dict[@"id"]];
        }
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
-(id)valueForKeyPath:(NSString *)keyPath
{
    return nil;
}
@end
