//
//  LocationManager.h
//  城市选择Demo
//
//  Created by Kenfor-YF on 16/6/1.
//  Copyright © 2016年 Kenfor-YF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
typedef void (^LocationBlock)(CLLocation *currentLocation, NSString *cityName);

@interface LocationManager : NSObject
+(LocationManager *)sharedOfLocation;
//获取地址
-(void)getCurrentLocation:(LocationBlock)locationBlock;

@end
