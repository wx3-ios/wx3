//
//  LuckyGoodsModel.m
//  RKWXT
//
//  Created by SHB on 15/8/13.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckyGoodsModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "LuckyGoodsEntity.h"

@interface LuckyGoodsModel(){
    NSMutableArray *_luckyGoodsArr;
}

@end

@implementation LuckyGoodsModel
@synthesize luckyGoodsArr = _luckyGoodsArr;

-(id)init{
    self = [super init];
    if(self){
        _luckyGoodsArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseLuckyGoodsWith:(NSArray*)arr{
    if(!arr){
        return;
    }
    if(_type == LuckyGoods_Type_Normal || _type == LuckyGoods_Type_Refresh){
        [_luckyGoodsArr removeAllObjects];
    }
    
    for(NSDictionary *dic in arr){
        LuckyGoodsEntity *entity = [LuckyGoodsEntity initLuckyGoodsWithDic:dic];
        entity.imgUrl = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.imgUrl];
        [_luckyGoodsArr addObject:entity];
    }
}

-(void)loadLuckyGoodsListWith:(NSInteger)startItem with:(NSInteger)length{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.sellerID, @"seller_user_id", userObj.wxtID, @"woxin_id", userObj.user, @"phone", [NSNumber numberWithInteger:kMerchantID], @"sid", [NSNumber numberWithInteger:startItem], @"start_item", [NSNumber numberWithInteger:length], @"length", nil];
    __block LuckyGoodsModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_LuckyGoodsList httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadLuckyGoodsFailed:)]){
                [_delegate loadLuckyGoodsFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseLuckyGoodsWith:[retData.data objectForKey:@"data"]];
            if(_delegate && [_delegate respondsToSelector:@selector(loadLuckyGoodsSuceeed)]){
                [_delegate loadLuckyGoodsSuceeed];
            }
        }
    }];
}

@end
