//
//  AllCityModel.m
//  RKWXT
//
//  Created by SHB on 15/11/3.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "AllCityModel.h"

@interface AllCityModel(){
    NSMutableArray *_cityList;
    NSMutableArray *_areaList;
    
    NSMutableArray *_allData;
}
@end

@implementation AllCityModel
@synthesize cityList = _cityList;
@synthesize areaList = _areaList;

-(id)init{
    if(self = [super init]){
        _cityList = [[NSMutableArray alloc] init];
        _areaList = [[NSMutableArray alloc] init];
        
        _allData = [[NSMutableArray alloc] init];
    }
    return self;
}

+(AllCityModel*)shareCityList{
    static dispatch_once_t onceToken;
    static AllCityModel *sharedInstance = nil;
    dispatch_once(&onceToken,^{
        sharedInstance = [[AllCityModel alloc] init];
    });
    return sharedInstance;
}

-(void)loadAllCity{
    [_cityList removeAllObjects];
    [_allData removeAllObjects];
    __block AllCityModel *selfCityModel = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @synchronized(selfCityModel){
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
            NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
            NSInteger count = [dictionary count];
            for(int i = 0; i < count; i++){
                NSString *key = [NSString stringWithFormat:@"%d",i];
                NSDictionary *item0 = [dictionary objectForKey:key];
                for(NSInteger j = 0;j < [item0 count]; j++){
                    NSString *province = [[item0 allKeys] objectAtIndex:0];  //省或自治区名字
                    NSDictionary *cityDic = [item0 objectForKey:province];
                    for(int k = 0; k < [cityDic count]; k++){
                        NSString *key1 = [NSString stringWithFormat:@"%d",k];
                        id cityData = [cityDic objectForKey:key1];
                        NSString *name = nil;
                        if([cityData isKindOfClass:[NSDictionary class]]){
                             name = [[cityData allKeys] objectAtIndex:0];
                        }
                        [_allData addObject:cityData];  //所有数组数据
                        [_cityList addObject:name];
                    }
                }
            }
        }
    });
}

-(void)loadAreaFromCity:(NSString *)cityName{
    [_areaList removeAllObjects];
    if([_allData count] == 0){
        return;
    }
    for(NSDictionary *dic in _allData){
        if([dic count] > 0){
            if([[[dic allKeys] objectAtIndex:0] isEqualToString:cityName]){
                NSArray *arr = [dic objectForKey:cityName];
                for(NSString *name in arr){
                    [_areaList addObject:name];
                }
            }
        }
    }
}

@end
