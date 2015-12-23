//
//  LMOrderListModel.m
//  RKWXT
//
//  Created by SHB on 15/12/21.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMOrderListModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "LMOrderListEntity.h"

@interface LMOrderListModel(){
    NSMutableArray *_orderList;
    NSInteger number;
}
@end

@implementation LMOrderListModel
@synthesize orderList = _orderList;

-(id)init{
    self = [super init];
    if(self){
        _orderList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseLmOrderListData:(NSArray*)arr{
    if(!arr){
        return;
    }
    if(number == 0){
        [_orderList removeAllObjects];
    }
    for(NSDictionary *dic in arr){
        NSMutableArray *goodsArr = [[NSMutableArray alloc] init];
        for(NSDictionary *goodsDic in [dic objectForKey:@"order_goods"]){
            LMOrderListEntity *goodsEntity = [LMOrderListEntity initLmOrderGoodsListEntity:goodsDic];
            goodsEntity.goodsImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,goodsEntity.goodsImg];
            [goodsArr addObject:goodsEntity];
        }
        LMOrderListEntity *entity = [LMOrderListEntity initLmOrderInfoEntity:[dic objectForKey:@"order_info"]];
        entity.goodsListArr = goodsArr;
        [_orderList addObject:entity];
    }
}

-(void)loadLMOrderList:(NSInteger)startItem andLength:(NSInteger)length type:(LMOrderList_Type)orderType{
    number = startItem;
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:kSubShopID], @"shop_id", [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.pwd],@"pwd", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)startItem], @"start_item", [NSNumber numberWithInt:length], @"length", [NSNumber numberWithInt:orderType], @"type", nil];
    __block LMOrderListModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_Home_LMorderList httpMethod:WXT_HttpMethod_Post timeoutIntervcal:10 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            if (_delegate && [_delegate respondsToSelector:@selector(loadLMOrderlistFailed:)]){
                [_delegate loadLMOrderlistFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseLmOrderListData:[retData.data objectForKey:@"data"]];
            if (_delegate && [_delegate respondsToSelector:@selector(loadLMOrderlistSucceed)]){
                [_delegate loadLMOrderlistSucceed];
            }
        }
    }];
}

@end
