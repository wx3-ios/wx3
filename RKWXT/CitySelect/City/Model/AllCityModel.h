//
//  AllCityModel.h
//  RKWXT
//
//  Created by SHB on 15/11/3.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllCityModel : NSObject
@property (nonatomic,strong) NSArray *cityList;
@property (nonatomic,strong) NSArray *areaList;

+(AllCityModel*)shareCityList;
-(void)loadAllCity;
-(void)loadAreaFromCity:(NSString*)cityName;

@end
