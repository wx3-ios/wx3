//
//  HomePageThemeModel.m
//  RKWXT
//
//  Created by SHB on 15/5/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "HomePageThemeModel.h"
#import "HomePageThmEntity.h"
#import "WXTURLFeedOBJ+NewData.h"

@interface HomePageThemeModel(){
    NSMutableArray *_dataList;
}
@end

@implementation HomePageThemeModel
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
        HomePageThmEntity *entity = [HomePageThmEntity homePageThmEntityWithDictionary:dic];
        entity.category_img = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.category_img];
        [_dataList addObject:entity];
    }
}

-(void)loadDataFromWeb{
    NSInteger shopID = kSubShopID;
    [self setStatus:E_ModelDataStatus_Loading];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", @"18613213051", @"phone", [UtilTool newStringWithAddSomeStr:5 withOldStr:@"123456"],@"pwd", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)kMerchantID], @"sid", [NSNumber numberWithInt:(int)shopID], @"shop_id", nil];
    __block HomePageThemeModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_NewMall_Theme httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            if (_delegate && [_delegate respondsToSelector:@selector(homePageThemeLoadedFailed:)]){
                [_delegate homePageThemeLoadedFailed:retData.errorDesc];
            }
        }else{
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
            [blockSelf fillDataWithJsonData:retData.data];
            [self saveCacheAtPath:[self currentCachePath] data:retData.data];
            if (_delegate && [_delegate respondsToSelector:@selector(homePageThemeLoadedSucceed)]){
                [_delegate homePageThemeLoadedSucceed];
            }
        }
    }];
}

-(void)loadCacheDataSucceed{
    if (_delegate && [_delegate respondsToSelector:@selector(homePageThemeLoadedSucceed)]){
        [_delegate homePageThemeLoadedSucceed];
    }
}

@end
