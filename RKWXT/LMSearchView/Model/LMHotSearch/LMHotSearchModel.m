//
//  LMHotSearchModel.m
//  RKWXT
//
//  Created by SHB on 15/12/28.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMHotSearchModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "LMSearchHotGoodsEntity.h"

@interface LMHotSearchModel(){
    NSMutableArray *_hotSearchList;
    LMSearchHot_Type hotType;
}
@end

@implementation LMHotSearchModel
@synthesize hotSearchList = _hotSearchList;

-(id)init{
    self = [super init];
    if(self){
        _hotSearchList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseLMHotSearchData:(NSDictionary *)dic{
    if(!dic){
        return;
    }
    [_hotSearchList removeAllObjects];
    if(hotType == LMSearchHot_Type_Goods){
        for(NSDictionary *goodsDic in [dic objectForKey:@"goods"]){
            [_hotSearchList addObject:[goodsDic objectForKey:@"keyword"]];
        }
    }
    if(hotType == LMSearchHot_Type_Seller){
        for(NSDictionary *goodsDic in [dic objectForKey:@"seller"]){
            [_hotSearchList addObject:[goodsDic objectForKey:@"keyword"]];
        }
    }
}

-(void)loadLMHotSearchData:(LMSearchHot_Type)type{
    hotType = type;
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", nil];
    __block LMHotSearchModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_Home_LMHotSearch httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadLMHotSearchDataFailed:)]){
                [_delegate loadLMHotSearchDataFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseLMHotSearchData:[retData.data objectForKey:@"data"]];
            if(_delegate && [_delegate respondsToSelector:@selector(loadLMHotSearchDataSucceed)]){
                [_delegate loadLMHotSearchDataSucceed];
            }
        }
    }];
}

@end
