//
//  LMHomeMoreHotGoodsModel.m
//  RKWXT
//
//  Created by SHB on 15/12/26.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMHomeMoreHotGoodsModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "ShopUnionHotGoodsEntity.h"

@interface LMHomeMoreHotGoodsModel(){
    NSMutableArray *_listArr;
    NSInteger _startItem;
}
@end

@implementation LMHomeMoreHotGoodsModel
@synthesize listArr = _listArr;

-(id)init{
    self = [super init];
    if(self){
        _listArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseMoreHotGoodsDat:(NSArray*)arr{
    if([arr count] == 0){
        return;
    }
    if(_startItem == 0){
        [_listArr removeAllObjects];
    }
    for(NSDictionary *dic in arr){
        ShopUnionHotGoodsEntity *entity = [ShopUnionHotGoodsEntity initHotGoodsEntityWithDic:dic];
        entity.goodsImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.goodsImg];
        [_listArr addObject:entity];
    }
}

-(void)loadLMHomeMoreHotGoods:(NSInteger)startItem length:(NSInteger)length{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    _startItem = startItem;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:kSubShopID], @"shop_id", [NSNumber numberWithInteger:kMerchantID], @"sid", [NSNumber numberWithInteger:1], @"type", [NSNumber numberWithInteger:startItem], @"start_item", [NSNumber numberWithInteger:length], @"length", nil];
    __block LMHomeMoreHotGoodsModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_Home_LoadMoreHot httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadMoreHotGoodsFailed:)]){
                [_delegate loadMoreHotGoodsFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseMoreHotGoodsDat:[retData.data objectForKey:@"data"]];
            if(_delegate && [_delegate respondsToSelector:@selector(loadMoreHotGoodsSucceed)]){
                [_delegate loadMoreHotGoodsSucceed];
            }
        }
    }];
}

@end
