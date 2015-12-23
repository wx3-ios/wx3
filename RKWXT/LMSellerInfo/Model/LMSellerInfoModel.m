//
//  LMSellerInfoModel.m
//  RKWXT
//
//  Created by SHB on 15/12/17.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMSellerInfoModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "LMSellerInfoEntity.h"

@interface LMSellerInfoModel(){
    NSMutableArray *_sellerInfoArr;
    NSMutableArray *_shopListArr;
}
@end

@implementation LMSellerInfoModel
@synthesize sellerInfoArr = _sellerInfoArr;
@synthesize shopListArr = _shopListArr;

-(id)init{
    self = [super init];
    if(self){
        _sellerInfoArr = [[NSMutableArray alloc] init];
        _shopListArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseLMSellerInfoData:(NSDictionary*)dic{
    if(!dic){
        return;
    }
    [_sellerInfoArr removeAllObjects];
    [_shopListArr removeAllObjects];
    
    LMSellerInfoEntity *entity1 = [LMSellerInfoEntity initSellerInfoEntity:[dic objectForKey:@"seller"]];
    entity1.imgUrlArr = [self goodsInfoTopImgArrWithImgString:entity1.imgUrl];
    [_sellerInfoArr addObject:entity1];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(NSDictionary *shopDic in [dic objectForKey:@"shop"]){
        [array removeAllObjects];
        LMSellerInfoEntity *entity = [LMSellerInfoEntity initShopInfoEtity:[shopDic objectForKey:@"shop"]];
        entity.shopImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.shopImg];
        for(NSDictionary *goodsDic in [shopDic objectForKey:@"goods"]){
            LMSellerInfoEntity *ent = [LMSellerInfoEntity initShopListEntity:goodsDic];
            ent.goodsImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,ent.goodsImg];
            [array addObject:ent];
        }
        entity.shopArr = array;
        [_shopListArr addObject:entity];
    }
}

-(NSArray*)goodsInfoTopImgArrWithImgString:(NSString*)imgStr{
    if(!imgStr){
        return nil;
    }
    NSMutableArray *imgArr = [[NSMutableArray alloc] init];
    NSArray *array = [imgStr componentsSeparatedByString:@","];
    for (NSString *str in array) {
        if([str isEqualToString:@""]){
            break;
        }
        NSString *str1 = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,str];
        [imgArr addObject:str1];
    }
    return imgArr;
}

-(void)loadLMSellerInfoData:(NSInteger)ssid{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:kMerchantID], @"sid", [NSNumber numberWithInteger:ssid], @"ssid", nil];
    __block LMSellerInfoModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_Home_LMSellerInfo httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadLMSellerInfoDataFailed:)]){
                [_delegate loadLMSellerInfoDataFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseLMSellerInfoData:[retData.data objectForKey:@"data"]];
            if(_delegate && [_delegate respondsToSelector:@selector(loadLMSellerInfoDataSucceed)]){
                [_delegate loadLMSellerInfoDataSucceed];
            }
        }
    }];
}

@end
