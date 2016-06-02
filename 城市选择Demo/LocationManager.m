//
//  LocationManager.m
//  城市选择Demo
//
//  Created by Kenfor-YF on 16/6/1.
//  Copyright © 2016年 Kenfor-YF. All rights reserved.
//

#import "LocationManager.h"
#import <SVProgressHUD.h>
static LocationManager *mgr;
@interface LocationManager()<CLLocationManagerDelegate>
@property(nonatomic,strong)CLLocationManager *locMgr;
@property(nonatomic,strong)LocationBlock locationBlock;
@end
@implementation LocationManager
+(LocationManager *)sharedOfLocation
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        mgr = [[self alloc]init];
    });
    return mgr;
}
-(instancetype)init
{
    if (self = [super init]) {
        [self initLocation];
    }
    return self;
}
-(void)initLocation
{
    self.locMgr = [[CLLocationManager alloc]init];
    self.locMgr.delegate = self;
    //定位精度
    self.locMgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
}
-(void)getCurrentLocation:(LocationBlock)locationBlock
{
    self.locationBlock = [locationBlock copy];
    [self locationAuthorzationJude];
}
#pragma mark - 判断定位授权
-(void)locationAuthorzationJude
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
   
    if (status == kCLAuthorizationStatusNotDetermined) {
        if ([_locMgr respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [_locMgr requestAlwaysAuthorization];
        }}else if (status == kCLAuthorizationStatusDenied){
            [SVProgressHUD showErrorWithStatus:@"请前往设置-隐私-定位中打开定位服务"];
        }else if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways){//授权允许可以获取用户的位置
            [_locMgr startUpdatingLocation];
        }
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
    [self.locMgr stopUpdatingLocation];
    CLGeocoder *gecoder = [[CLGeocoder alloc]init];
    [gecoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placeMark = [placemarks objectAtIndex:0];
        if (placeMark != nil) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:10];
            [dic setObject:placeMark forKey:@"placeMark"];
            [dic setObject:location forKey:@"location"];
            NSString *cityUID;
            CLPlacemark *placeMark = [dic objectForKey:@"placeMark"];
            if (placeMark.locality == nil) {
                cityUID = placeMark.administrativeArea;
            }else{
                cityUID = placeMark.locality;
            }
            NSString *cityName = [self getCityByID:cityUID];
            if ([cityName isEqualToString:@"不能发现城市"]) {
                cityName = [cityUID stringByReplacingOccurrencesOfString:@"市" withString:@""];
            }
            CLLocation *currentLocation = [dic objectForKey:@"location"];
            if (_locationBlock) {
                _locationBlock(currentLocation,cityName);
            }
        }
    }];
}
-(NSString *)getCityByID:(NSString *)cityID
{
    NSString *AllcityName = [[NSBundle mainBundle]pathForResource:@"AllCityName" ofType:nil];
    NSError *error = nil;
    NSString *name = [[NSString alloc]initWithContentsOfFile:AllcityName encoding:NSUTF8StringEncoding error:&error];
    NSString *AllCityID = [[NSBundle mainBundle]pathForResource:@"AllCityID" ofType:nil];
    NSString *ID = [[NSString alloc]initWithContentsOfFile:AllCityID encoding:NSUTF8StringEncoding error:&error];
    int arrayIndex = -1;
    NSArray *cityNameArray = [name componentsSeparatedByString:@"city="];
    NSArray *cityIDArray = [ID componentsSeparatedByString:@"ID="];
    for (int i=0; i<cityIDArray.count; i++) {
        if ([cityIDArray[i] compare:cityID options:NSCaseInsensitiveSearch] == 0) {
            arrayIndex = i;
            break;
        }
    }
    if (arrayIndex == -1) {
        return @"不能发现城市";
    }
    return cityNameArray[arrayIndex];
}
@end
