//
//  WXTMallModel.m
//  RKWXT
//
//  Created by SHB on 15/3/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTMallModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+Data.h"
#import "MallEntity.h"

@interface WXTMallModel(){
    NSMutableArray *_mallDataArr;
}
@end

@implementation WXTMallModel
@synthesize mallDataArr = _mallDataArr;

-(id)init{
    if(self = [super init]){
        _mallDataArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseClassifyData:(id)data{
    if(!data){
        return;
    }
    if([data isKindOfClass:[NSDictionary class]]){
        MallEntity *entity = [MallEntity initMallDataWithDic:data];
        [_mallDataArr addObject:entity];
    }
}

-(void)loadMallData{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"get_mall_home_url", @"cmd", userObj.wxtID, @"user_id", [NSNumber numberWithInt:ShopID], @"agent_id", [NSNumber numberWithInt:AreaID], @"area_id", [NSNumber numberWithInt:SubShopID], @"shop_id", userObj.token, @"token", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchDataFromFeedType:WXT_UrlFeed_Type_LoadBalance httpMethod:WXT_HttpMethod_Get timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData){
        NSDictionary *dic = retData.data;
        __block WXTMallModel *blockSelf = self;
        if ([[dic objectForKey:@"success"] integerValue] != 1){
            if (_mallDelegate && [_mallDelegate respondsToSelector:@selector(initMalldataFailed:)]){
                [_mallDelegate initMalldataFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseClassifyData:retData.data];
            if (_mallDelegate && [_mallDelegate respondsToSelector:@selector(initMalldataSucceed)]){
                [_mallDelegate initMalldataSucceed];
            }
        }
    }];
}

@end
