//
//  LocalAreaModel.m
//  RKWXT
//
//  Created by SHB on 15/11/5.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LocalAreaModel.h"
#import "AreaDataSql.h"
#import "AreaEntity.h"

@interface LocalAreaModel(){
    NSDictionary *localDic;
    
    NSMutableArray *_provinceArr;
    NSMutableArray *_cityArr;
    NSMutableDictionary *_citiesDic;
    NSMutableDictionary *_districtDic;
}
@end

@implementation LocalAreaModel
@synthesize provinceArr = _provinceArr;
@synthesize cityArr = _cityArr;
@synthesize citiesDic = _citiesDic;
@synthesize districtDic = _districtDic;

+(LocalAreaModel*)shareLocalArea{
    static dispatch_once_t onceToken;
    static LocalAreaModel *sharedInstance = nil;
    dispatch_once(&onceToken,^{
        sharedInstance = [[LocalAreaModel alloc] init];
    });
    return sharedInstance;
}

-(id)init{
    self = [super init];
    if(self){
        _provinceArr = [[NSMutableArray alloc] init];
        _cityArr = [[NSMutableArray alloc] init];
        _citiesDic = [[NSMutableDictionary alloc] init];
        _districtDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)loadLocalAreaData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"test3.plist"];
        NSMutableDictionary *infolist = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        localDic = infolist;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self startLoadAreaData];
        });
    });
}

-(void)startLoadAreaData{
    [self loadAllProvince:localDic];
}

-(void)loadAllProvince:(NSDictionary*)dic{
    [_provinceArr removeAllObjects];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for(NSInteger i = 0; i < [dic count]; i++){
            NSDictionary *d = [dic objectForKey:[NSString stringWithFormat:@"%ld",(long)i]];
            if([[d objectForKey:@"parent_id"] integerValue] == 0){
                AreaEntity *entity = [[AreaEntity alloc] init];
                entity.areaID = [[d objectForKey:@"area_id"] integerValue];
                entity.areaName = [d objectForKey:@"area_name"];
                entity.areaPresentID = [[d objectForKey:@"parent_id"] integerValue];
                [_provinceArr addObject:entity];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if([_provinceArr count] > 0){
                AreaEntity *entity = [_provinceArr objectAtIndex:0];
                _selectedProvince = entity.areaName;
                _areaEntity = entity;
//                [self loadAllCity:dic];  //省份过滤后过滤市
//                [self loadLocalCity:dic];
            }
        });
    });
}

//根据省获取市, 商家联盟时候用到
-(void)loadLocalCity:(NSDictionary *)dic{
    [_cityArr removeAllObjects];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for(AreaEntity *entity in _provinceArr){
            for(NSInteger i = 0; i < [dic count]; i++){
                NSDictionary *d = [dic objectForKey:[NSString stringWithFormat:@"%ld",(long)i]];
                if([[d objectForKey:@"parent_id"] integerValue] == entity.areaID){
                    AreaEntity *ent = [[AreaEntity alloc] init];
                    ent.areaID = [[d objectForKey:@"area_id"] integerValue];
                    ent.areaName = [d objectForKey:@"area_name"];
                    ent.areaPresentID = [[d objectForKey:@"parent_id"] integerValue];
                    [_cityArr addObject:ent];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //市过滤后过滤区县
//            [self loadLocalDistrict:dic];
        });
    });
}

//根据省获取市的字典
-(void)loadAllCity:(NSDictionary*)dic{
    [_citiesDic removeAllObjects];
    __block NSMutableArray *cityList = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *array = [NSArray arrayWithArray:_provinceArr];
        for(AreaEntity *entity in array){
            [cityList removeAllObjects];
            for(NSInteger i = 0; i < [dic count]; i++){
                NSDictionary *d = [dic objectForKey:[NSString stringWithFormat:@"%ld",(long)i]];
                if([[d objectForKey:@"parent_id"] integerValue] == entity.areaID){
                    AreaEntity *ent = [[AreaEntity alloc] init];
                    ent.areaID = [[d objectForKey:@"area_id"] integerValue];
                    ent.areaName = [d objectForKey:@"area_name"];
                    ent.areaPresentID = [[d objectForKey:@"parent_id"] integerValue];
                    [cityList addObject:ent];
                }
            }
            [_citiesDic setObject:cityList forKey:[NSString stringWithFormat:@"%ld",(long)entity.areaID]];
        }
    });
}

-(void)loadLocalDistrict:(NSDictionary*)dic{
    [_districtDic removeAllObjects];
    __block NSMutableArray *disList = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *array = [NSArray arrayWithArray:_cityArr];
        for(AreaEntity *entity in array){
            [disList removeAllObjects];
            for(NSInteger i = 0; i < [dic count]; i++){
                NSDictionary *d = [dic objectForKey:[NSString stringWithFormat:@"%ld",(long)i]];
                if([[d objectForKey:@"parent_id"] integerValue] == entity.areaID){
                    AreaEntity *ent = [[AreaEntity alloc] init];
                    ent.areaID = [[d objectForKey:@"area_id"] integerValue];
                    ent.areaName = [d objectForKey:@"area_name"];
                    ent.areaPresentID = [[d objectForKey:@"parent_id"] integerValue];
                    [disList addObject:ent];
                }
            }
            [_districtDic setObject:disList forKey:[NSString stringWithFormat:@"%ld",(long)entity.areaID]];
        }
    });
}

//以上方法有点问题
-(NSArray *)searchCityArrayWithProvinceID:(NSInteger)provinceID{
    NSMutableArray *cityListArr = [[NSMutableArray alloc] init];
    for(NSInteger i = 0; i < [localDic count]; i++){
        NSDictionary *dic = [localDic objectForKey:[NSString stringWithFormat:@"%ld",(long)i]];
        if([[dic objectForKey:@"parent_id"] integerValue] == provinceID){
            AreaEntity *ent = [[AreaEntity alloc] init];
            ent.areaID = [[dic objectForKey:@"area_id"] integerValue];
            ent.areaName = [dic objectForKey:@"area_name"];
            ent.areaPresentID = [[dic objectForKey:@"parent_id"] integerValue];
            [cityListArr addObject:ent];
        }
    }
    return cityListArr;
}

-(NSArray*)searchDistricArrayWithCityID:(NSInteger)cityID{
    NSMutableArray *districtArr = [[NSMutableArray alloc] init];
    for(NSInteger i = 0; i < [localDic count]; i++){
        NSDictionary *dic = [localDic objectForKey:[NSString stringWithFormat:@"%ld",(long)i]];
        if([[dic objectForKey:@"parent_id"] integerValue] == cityID){
            AreaEntity *ent = [[AreaEntity alloc] init];
            ent.areaID = [[dic objectForKey:@"area_id"] integerValue];
            ent.areaName = [dic objectForKey:@"area_name"];
            ent.areaPresentID = [[dic objectForKey:@"parent_id"] integerValue];
            [districtArr addObject:ent];
        }
    }
    return districtArr;
}

@end
