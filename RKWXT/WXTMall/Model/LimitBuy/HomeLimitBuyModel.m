//
//  HomeLimitBuyModel.m
//  RKWXT
//
//  Created by SHB on 15/11/27.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "HomeLimitBuyModel.h"
#import "HomeLimitBuyEntity.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "TimeShopData.h"

@interface HomeLimitBuyModel(){
    NSMutableArray *_dataList;
}
@end

@implementation HomeLimitBuyModel
@synthesize data = _dataList;

-(id)init{
    if(self = [super init]){
        _dataList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)toInit{
    [super toInit];
    [_dataList removeAllObjects];
}

-(void)fillDataWithJsonData:(NSDictionary *)jsonDicData{
    if(!jsonDicData){
        return;
    }
    [_dataList removeAllObjects];
    NSArray *datalist = [jsonDicData objectForKey:@"data"];
    for(NSDictionary *dic in datalist){
        TimeShopData *limitEntity = [[TimeShopData alloc] init];
        limitEntity.begin_time = [dic objectForKey:@"begin_time"];
        limitEntity.end_time = [dic objectForKey:@"end_time"];
        limitEntity.goods_price = [dic objectForKey:@"goods_price"];
        limitEntity.scare_buying_number = [dic objectForKey:@"scare_buying_number"];
        limitEntity.scare_buying_price = [dic objectForKey:@"scare_buying_price"];
        limitEntity.goods_name = [dic objectForKey:@"goods_name"];
        limitEntity.goods_home_img = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,[dic objectForKey:@"goods_home_img"]];
        limitEntity.goods_id = [dic objectForKey:@"goods_id"];
        limitEntity.scare_buying_id = [dic objectForKey:@"scare_buying_id"];
        limitEntity.user_scare_buying_number = [dic objectForKey:@"user_scare_buying_number"];
        [_dataList addObject:limitEntity];
    }
}

-(void)loadDataFromWeb{
    [self setStatus:E_ModelDataStatus_Loading];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:4], @"type", [NSNumber numberWithInt:(int)kSubShopID], @"shop_id", nil];
    __block HomeLimitBuyModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_TimeToBuy httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            if (_delegate && [_delegate respondsToSelector:@selector(homeLimitBuyLoadFailed:)]){
                [_delegate homeLimitBuyLoadFailed:retData.errorDesc];
            }
        }else{
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
            [blockSelf fillDataWithJsonData:retData.data];
            [self saveCacheAtPath:[self currentCachePath] data:retData.data];
            if (_delegate && [_delegate respondsToSelector:@selector(homeLimitBuyLoadSucceed)]){
                [_delegate homeLimitBuyLoadSucceed];
            }
        }
    }];
}

-(void)loadCacheDataSucceed{
    if (_delegate && [_delegate respondsToSelector:@selector(homeLimitBuyLoadSucceed)]){
        [_delegate homeLimitBuyLoadSucceed];
    }
}

@end
