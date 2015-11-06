//
//  LocalAreaModel.h
//  RKWXT
//
//  Created by SHB on 15/11/5.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AreaEntity;

#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

#define AreaForCity @"AreaForCity"
#define AreaForDistrict @"AreaForDistrict"

@interface LocalAreaModel : NSObject
@property (nonatomic,strong) NSArray *provinceArr;  //所有省
@property (nonatomic,strong) NSArray *cityArr;      //所有市
@property (nonatomic,strong) NSDictionary *citiesDic;  //根据省为KEY获取市的字典
@property (nonatomic,strong) NSDictionary *districtDic;  //根据市为KEY获取县的字典
@property (nonatomic,strong) NSString *selectedProvince;
@property (nonatomic,strong) AreaEntity *areaEntity;

+(LocalAreaModel*)shareLocalArea;
-(void)loadLocalAreaData;

//搜索
-(NSArray *)searchCityArrayWithProvinceID:(NSInteger)provinceID;
-(NSArray *)searchDistricArrayWithCityID:(NSInteger)cityID;

@end
