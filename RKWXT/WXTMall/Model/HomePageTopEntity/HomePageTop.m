//
//  HomePageTop.m
//  RKWXT
//
//  Created by SHB on 15/5/29.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "HomePageTop.h"
#import "WXTURLFeedOBJ.h"

@interface HomePageTop(){
    NSMutableArray *_dataList;
}
@end

@implementation HomePageTop
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
}

-(void)loadDataFromWeb{
    NSInteger shopID = [WXUserOBJ sharedUserOBJ].subShopID;
    NSInteger merchantID = kMerchantID;
    NSInteger areaID = kAreaID;
    [self setStatus:E_ModelDataStatus_Loading];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:shopID],@"shop_id", [NSNumber numberWithInteger:merchantID],@"seller_id",[NSNumber numberWithInteger:areaID],@"area_id",nil];
    __block HomePageTop *blockSelf = self;
//    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchDataFromFeedType:WXT_UrlFeed_Type_Sign httpMethod:E_HttpMethod_Get timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData){
//        if (retData.code != E_URLFeedData_Succeed){
//            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
//            if (_delegate && [_delegate respondsToSelector:@selector(homePageTopLoadedFailed:)]){
//                [_delegate homePageTopLoadedFailed:retData.errorDesc];
//            }
//        }else{
//            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
//            [blockSelf fillDataWithJsonData:retData.data];
//            [self saveChacheAtPath:[self currentCachePath] data:retData.data];
//            if (_delegate && [_delegate respondsToSelector:@selector(homePageTopLoadedSucceed)]){
//                [_delegate homePageTopLoadedSucceed];
//            }
//        }
//    }];
}

@end
