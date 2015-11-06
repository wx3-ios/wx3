//
//  CityAddress.h
//  RKWXT
//
//  Created by SHB on 15/11/4.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

@interface CityAddress : NSObject
@property (nonatomic,strong) NSDictionary *areaDic;
@property (nonatomic,strong) NSArray *province;
@property (nonatomic,strong) NSArray *city;
@property (nonatomic,strong) NSArray *district;
@property (nonatomic,strong) NSString *selectedProvince;

-(void)loadUserAddressData;

@end
