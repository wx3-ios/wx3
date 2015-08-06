//
//  HomePageSurpModel.m
//  RKWXT
//
//  Created by SHB on 15/5/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "HomePageSurpModel.h"
#import "HomePageSurpEntity.h"
#import "WXTURLFeedOBJ+NewData.h"

@interface HomePageSurpModel(){
    NSMutableArray *_dataList;
}
@end

@implementation HomePageSurpModel
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
    NSArray *list = [jsonDicData objectForKey:@"data"];
    for(NSDictionary *dic in list){
        HomePageSurpEntity *entity = [HomePageSurpEntity homePageSurpEntityWithDictionary:dic];
        entity.home_img = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.home_img];
        [_dataList addObject:entity];
    }
}

-(void)loadDataFromWeb{
    NSInteger shopID = kSubShopID;
    [self setStatus:E_ModelDataStatus_Loading];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.sellerID, @"seller_user_id", @"iOS", @"pid", userObj.user, @"phone", [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.pwd],@"pwd", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)kMerchantID], @"sid", [NSNumber numberWithInt:(int)shopID], @"shop_id", nil];
    __block HomePageSurpModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_NewMall_Surprise httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            if (_delegate && [_delegate respondsToSelector:@selector(homePageSurpLoadedFailed:)]){
                [_delegate homePageSurpLoadedFailed:retData.errorDesc];
            }
        }else{
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
            [blockSelf fillDataWithJsonData:retData.data];
            [self saveCacheAtPath:[self currentCachePath] data:retData.data];
            if (_delegate && [_delegate respondsToSelector:@selector(homePageSurpLoadedSucceed)]){
                [_delegate homePageSurpLoadedSucceed];
            }
        }
    }];
}

-(void)loadCacheDataSucceed{
    if(_delegate && [_delegate respondsToSelector:@selector(homePageSurpLoadedSucceed)]){
        [_delegate homePageSurpLoadedSucceed];
    }
}

@end
