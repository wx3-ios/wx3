//
//  LMGoodsInfoModel.m
//  RKWXT
//
//  Created by SHB on 15/12/17.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMGoodsInfoModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "LMGoodsInfoEntity.h"

@interface LMGoodsInfoModel(){
    NSMutableArray *_goodsInfoArr;
    NSMutableArray *_evaluteArr;
    NSMutableArray *_attrArr;
    NSMutableArray *_stockArr;
    NSMutableArray *_otherShopArr;
    NSMutableArray *_sellerArr;
}
@end

@implementation LMGoodsInfoModel
@synthesize goodsInfoArr = _goodsInfoArr;
@synthesize evaluteArr = _evaluteArr;
@synthesize attrArr = _attrArr;
@synthesize stockArr = _stockArr;
@synthesize otherShopArr = _otherShopArr;
@synthesize sellerArr = _sellerArr;

-(id)init{
    self = [super init];
    if(self){
        _goodsInfoArr = [[NSMutableArray alloc] init];
        _stockArr = [[NSMutableArray alloc] init];
        _evaluteArr = [[NSMutableArray alloc] init];
        _attrArr = [[NSMutableArray alloc] init];
        _otherShopArr = [[NSMutableArray alloc] init];
        _sellerArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseGoodsInfoData:(NSDictionary*)dic{
    if(!dic){
        return;
    }
    [_goodsInfoArr removeAllObjects];
    [_stockArr removeAllObjects];
    [_attrArr removeAllObjects];
    [_evaluteArr removeAllObjects];
    [_otherShopArr removeAllObjects];
    [_sellerArr removeAllObjects];
    
    //商品详情
    LMGoodsInfoEntity *goodsInfoEntity = [LMGoodsInfoEntity initGoodsInfoEntity:[dic objectForKey:@"goods"]];
    goodsInfoEntity.homeImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,goodsInfoEntity.homeImg];
    goodsInfoEntity.goodsImgArr = [self goodsInfoTopImgArrWithImgString:goodsInfoEntity.goodsImg];
    [_goodsInfoArr addObject:goodsInfoEntity];
    
    //商家信息
    LMGoodsInfoEntity *sellerEntity = [LMGoodsInfoEntity initSellerInfoEntity:[dic objectForKey:@"seller"]];
    [_sellerArr addObject:sellerEntity];
    
    //基础信息
    for(NSDictionary *attrDic in [dic objectForKey:@"attr"]){
        LMGoodsInfoEntity *attrEntity = [LMGoodsInfoEntity initBaseAttrDataEntity:attrDic];
        [_attrArr addObject:attrEntity];
    }
    
    //评价
    for(NSDictionary *evaluateDic in [dic objectForKey:@"evaluate"]){
        LMGoodsInfoEntity *evaluateEntity = [LMGoodsInfoEntity initEvaluteDataEntity:evaluateDic];
        evaluateEntity.userHeadImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,evaluateEntity.userHeadImg];
        [_evaluteArr addObject:evaluateEntity];
    }
    
    //推荐店铺
    for(NSDictionary *shopDic in [dic objectForKey:@"shop"]){
        LMGoodsInfoEntity *shopEntity = [LMGoodsInfoEntity initOtherShopEntity:shopDic];
        [_otherShopArr addObject:shopEntity];
    }
    
    //库存
    for(NSDictionary *stockDic in [dic objectForKey:@"stock"]){
        LMGoodsInfoEntity *stockEntity = [LMGoodsInfoEntity initStockDataEntity:stockDic];
        [_stockArr addObject:stockEntity];
    }
}

-(NSArray*)goodsInfoTopImgArrWithImgString:(NSString*)imgStr{
    if(!imgStr){
        return nil;
    }
    NSMutableArray *imgArr = [[NSMutableArray alloc] init];
    NSArray *array = [imgStr componentsSeparatedByString:@","];
    for (NSString *str in array) {
        NSString *str1 = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,str];
        [imgArr addObject:str1];
    }
    return imgArr;
}

-(void)loadGoodsInfoData:(NSInteger)goodsID{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithInteger:kMerchantID], @"sid", [NSNumber numberWithFloat:[self userLatitude]], @"latitude", [NSNumber numberWithFloat:[self userLongitude]], @"longitude", [NSNumber numberWithInteger:goodsID], @"goods_id", nil];
    __block LMGoodsInfoModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_Home_LMGoodsInfo httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadGoodsInfoDataFailed:)]){
                [_delegate loadGoodsInfoDataFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseGoodsInfoData:[retData.data objectForKey:@"data"]];
            if(_delegate && [_delegate respondsToSelector:@selector(loadGoodsInfoDataSucceed)]){
                [_delegate loadGoodsInfoDataSucceed];
            }
        }
    }];
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
