//
//  HomePageRecModel.m
//  RKWXT
//
//  Created by SHB on 15/5/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "HomePageRecModel.h"
#import "HomePageRecEntity.h"
#import "WXTURLFeedOBJ+NewData.h"

@interface HomePageRecModel(){
    NSMutableArray *_dataList;
}
@end

@implementation HomePageRecModel
@synthesize data = _dataList;

-(id)init{
    self = [super init];
    if(self){
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
        HomePageRecEntity *entity = [HomePageRecEntity homePageRecEntityWithDictionary:dic];
        entity.home_img = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.home_img];
        [_dataList addObject:entity];
    }
}

-(void)loadDataFromWeb{
    NSInteger shopID = kSubShopID;
    [self setStatus:E_ModelDataStatus_Loading];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.sellerID, @"seller_user_id", @"iOS", @"pid", userObj.user, @"phone", [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.pwd], @"pwd", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)kMerchantID], @"sid", [NSNumber numberWithInt:(int)shopID], @"shop_id", nil];
    __block HomePageRecModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_NewMall_Recommond httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            if (_delegate && [_delegate respondsToSelector:@selector(homePageRecLoadedFailed:)]){
                [_delegate homePageRecLoadedFailed:retData.errorDesc];
            }
        }else{
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
            [blockSelf fillDataWithJsonData:retData.data];
            [self saveCacheAtPath:[self currentCachePath] data:retData.data];
            if (_delegate && [_delegate respondsToSelector:@selector(homePageRecLoadedSucceed)]){
                [_delegate homePageRecLoadedSucceed];
            }
        }
    }];
}

-(void)loadCacheDataSucceed{
    if (_delegate && [_delegate respondsToSelector:@selector(homePageRecLoadedSucceed)]){
        [_delegate homePageRecLoadedSucceed];
    }
}

@end
