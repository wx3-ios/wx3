//
//  WXShopUnionModel.m
//  RKWXT
//
//  Created by SHB on 15/12/7.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXShopUnionModel.h"
#import "WXTURLFeedOBJ+NewData.h"

#import "ShopUnionClassifyEntity.h"
#import "ShopUnionHotGoodsEntity.h"
#import "ShopUnionHotShopEntity.h"

@interface WXShopUnionModel(){
    NSMutableArray *_hotGoodsArr;
    NSMutableArray *_hotShopArr;
    NSMutableArray *_classifyShopArr;
    NSMutableArray *_activityArr;
}
@end

@implementation WXShopUnionModel
@synthesize hotGoodsArr = _hotGoodsArr;
@synthesize hotShopArr = _hotShopArr;
@synthesize classifyShopArr = _classifyShopArr;
@synthesize activityArr = _activityArr;

-(id)init{
    self = [super init];
    if(self){
        _hotGoodsArr = [[NSMutableArray alloc] init];
        _hotShopArr = [[NSMutableArray alloc] init];
        _classifyShopArr = [[NSMutableArray alloc] init];
        _activityArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseShopUnionData:(NSDictionary*)dic1{
    if(!dic1){
        return;
    }
    [_hotGoodsArr removeAllObjects];
    [_hotShopArr removeAllObjects];
    [_classifyShopArr removeAllObjects];
    [_activityArr removeAllObjects];
    
//    NSArray *goodsArr = [dic1 objectForKey:@"goods"];
    NSArray *classifyArr = [dic1 objectForKey:@"industry"];
    NSArray *sellerArr = [dic1 objectForKey:@"seller"];
    
//    for(NSDictionary *dic in goodsArr){
//        ShopUnionHotGoodsEntity *entity = [ShopUnionHotGoodsEntity initHotGoodsEntityWithDic:dic];
//        entity.goodsImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.goodsImg];
//        [_hotGoodsArr addObject:entity];
//    }
    
    for(NSDictionary *dic in classifyArr){
        ShopUnionClassifyEntity *entity = [ShopUnionClassifyEntity initClassifyEntityWithDic:dic];
        entity.industryImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.industryImg];
        [_classifyShopArr addObject:entity];
    }
    
    for(NSDictionary *dic in sellerArr){
        ShopUnionHotShopEntity *entity = [ShopUnionHotShopEntity initShopUnionHotShopEntity:dic];
        entity.sellerLogo = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.sellerLogo];
        [_hotShopArr addObject:entity];
    }
}

-(void)loadShopUnionData:(NSInteger)areaID{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:kSubShopID], @"shop_id", [NSNumber numberWithInteger:kMerchantID], @"sid", [self userProvincialName], @"provincial_name", [self userCityName], @"municipality_name", [self userCountyName], @"county_name", [NSNumber numberWithFloat:[self userLatitude]], @"latitude", [NSNumber numberWithFloat:[self userLongitude]], @"longitude", [NSNumber numberWithInteger:areaID], @"area_id", nil];
    __block WXShopUnionModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_Home_ShopUnion httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadShopUnionDataFailed:)]){
                [_delegate loadShopUnionDataFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseShopUnionData:[retData.data objectForKey:@"data"]];
            if(_delegate && [_delegate respondsToSelector:@selector(loadShopUnionDataSucceed)]){
                [_delegate loadShopUnionDataSucceed];
            }
        }
    }];
}

//用户所在省份
-(NSString*)userProvincialName{
    WXUserOBJ *userObj = [WXUserOBJ sharedUserOBJ];
    if(userObj.userLocationPro){
        return userObj.userLocationPro;
    }
    return @"";
}
//用户所在市
-(NSString*)userCityName{
    WXUserOBJ *userObj = [WXUserOBJ sharedUserOBJ];
    if(userObj.userLocationCity){
        return userObj.userLocationCity;
    }
    return @"";
}
//用户所在市
-(NSString*)userCountyName{
    WXUserOBJ *userObj = [WXUserOBJ sharedUserOBJ];
    if(userObj.userLocationArea){
        return userObj.userLocationArea;
    }
    return @"";
}
//用户定位纬度
-(CGFloat)userLatitude{
    WXUserOBJ *userObj = [WXUserOBJ sharedUserOBJ];
    if(userObj.userLocationLatitude > 0){
        return userObj.userLocationLatitude;
    }
    return 0.0;
}
//用户定位经度
-(CGFloat)userLongitude{
    WXUserOBJ *userObj = [WXUserOBJ sharedUserOBJ];
    if(userObj.userLocationLongitude > 0){
        return userObj.userLocationLongitude;
    }
    return 0.0;
}


@end
