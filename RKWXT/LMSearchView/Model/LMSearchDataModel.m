//
//  LMSearchDataModel.m
//  RKWXT
//
//  Created by SHB on 15/12/25.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMSearchDataModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "LMSearchGoodsEntity.h"
#import "LMSearchSellerEntity.h"

@interface LMSearchDataModel(){
    NSMutableArray *_searchListArr;
}
@end

@implementation LMSearchDataModel
@synthesize searchListArr = _searchListArr;

-(id)init{
    self = [super init];
    if(self){
        _searchListArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseSearchResultData:(LMSearch_Type)type with:(NSArray*)arr{
    if(type > LMSearch_Type_Seller || [arr count] == 0){
        return;
    }
    [_searchListArr removeAllObjects];
    if(type == LMSearch_Type_Goods){
        for(NSDictionary *dic in arr){
            LMSearchGoodsEntity *entity = [LMSearchGoodsEntity initLMSearchGoodsEntity:dic];
            entity.goodsImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.goodsImg];
            [_searchListArr addObject:entity];
        }
    }
    if(type == LMSearch_Type_Seller){
        for(NSDictionary *dic in arr){
            LMSearchSellerEntity *entity = [LMSearchSellerEntity initLMSearchSellerEntity:dic];
            entity.imgUrl = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.imgUrl];
            [_searchListArr addObject:entity];
        }
    }
}

-(void)lmSearchInputKeyword:(NSString *)keyword searchType:(LMSearch_Type)type{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithInteger:kMerchantID], @"sid", [NSNumber numberWithInteger:type], @"type", keyword, @"keyword", nil];
    __block LMSearchDataModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_Home_LMSearch httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(lmSearchDataFailed:)]){
                [_delegate lmSearchDataFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseSearchResultData:type with:[retData.data objectForKey:@"data"]];
            if(_delegate && [_delegate respondsToSelector:@selector(lmSearchDataSucceed)]){
                [_delegate lmSearchDataSucceed];
            }
        }
    }];
}

@end
