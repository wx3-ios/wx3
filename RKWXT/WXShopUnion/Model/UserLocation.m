//
//  UserLocation.m
//  RKWXT
//
//  Created by SHB on 15/11/21.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "UserLocation.h"
#import <CoreLocation/CoreLocation.h>

@interface UserLocation()<CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
}
@end

@implementation UserLocation

-(void)startLocation{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = 10;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
                [locationManager requestAlwaysAuthorization];
            }
            break;
            
        default:
            break;
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    WXUserOBJ *userObj = [WXUserOBJ sharedUserOBJ];
    [userObj setUserLocationLatitude:currentLocation.coordinate.latitude];
    [userObj setUserLocationLongitude:currentLocation.coordinate.longitude];
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error) {
        if(array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            NSLog(@"当前位置%@",placemark.name);
            NSLog(@"当前所属区域 = %@",placemark.subLocality);
            [userObj setUserLocationArea:placemark.subLocality];
            //获取城市
            NSString *city = placemark.locality;
            if(!city){
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSString * cityName = nil;
            cityName = city;
            NSLog(@"定位完成:%@",cityName);
            [userObj setUserLocationCity:cityName];
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_UserLocation_Succeed object:nil];
            //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
            [manager stopUpdatingLocation];
        }else if (error == nil && [array count] == 0){
            NSLog(@"No results were returned.");
        }else if (error != nil){
            NSLog(@"An error occurred = %@", error);
        }
    }];
}


@end
