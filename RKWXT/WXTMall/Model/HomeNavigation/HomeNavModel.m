//
//  HomeNavModel.m
//  RKWXT
//
//  Created by SHB on 15/6/17.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "HomeNavModel.h"
#import "HomeNavENtity.h"
#import "WXTURLFeedOBJ+NewData.h"

@interface HomeNavModel(){
    NSMutableArray *_dataList;
}
@end

@implementation HomeNavModel
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
        HomeNavENtity *entity = [HomeNavENtity homeNavigationEntityWithDic:dic];
        entity.imgUrl = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.imgUrl];
        [_dataList addObject:entity];
    }
}

-(void)loadDataFromWeb{
    NSInteger shopID = kSubShopID;
    [self setStatus:E_ModelDataStatus_Loading];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", @"18613213051", @"phone", [UtilTool newStringWithAddSomeStr:5 withOldStr:@"123456"],@"pwd", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)kMerchantID], @"sid", [NSNumber numberWithInt:(int)shopID], @"shop_id", nil];
    __block HomeNavModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_NewMall_Nav httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            if (_delegate && [_delegate respondsToSelector:@selector(homeNavigationLoadFailed:)]){
                [_delegate homeNavigationLoadFailed:retData.errorDesc];
            }
        }else{
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
            [blockSelf fillDataWithJsonData:retData.data];
            [self saveCacheAtPath:[self currentCachePath] data:retData.data];
            if (_delegate && [_delegate respondsToSelector:@selector(homeNavigationLoadSucceed)]){
                [_delegate homeNavigationLoadSucceed];
            }
        }
    }];
}

-(void)loadCacheDataSucceed{
    if (_delegate && [_delegate respondsToSelector:@selector(homeNavigationLoadSucceed)]){
        [_delegate homeNavigationLoadSucceed];
    }
}

@end
