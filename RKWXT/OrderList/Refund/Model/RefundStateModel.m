//
//  RefundStateModel.m
//  RKWXT
//
//  Created by SHB on 15/7/9.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "RefundStateModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "RefundStateEntity.h"

@interface RefundStateModel(){
    NSMutableArray *_refundStateArr;
}
@end

@implementation RefundStateModel
@synthesize refundStateArr = _refundStateArr;

-(id)init{
    self = [super init];
    if(self){
        _refundStateArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)loadRefundInfoWith:(NSInteger)orderGoodsID{
    [self setStatus:E_ModelDataStatus_Loading];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userObj.user, @"phone", [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.pwd], @"pwd", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)orderGoodsID], @"order_goods_id", [NSNumber numberWithInteger:kSubShopID], @"shop_id", nil];
    __block RefundStateModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_RefundInfo httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            if(_delegate && [_delegate respondsToSelector:@selector(loadRefundStateFailed:)]){
                [_delegate loadRefundStateFailed:retData.errorDesc];
            }
        }else{
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
            [blockSelf parseRefundStateWithDic:[retData.data objectForKey:@"data"]];
            if(_delegate && [_delegate respondsToSelector:@selector(loadRefundStateSucceed)]){
                [_delegate loadRefundStateSucceed];
            }
        }
    }];
}

-(void)parseRefundStateWithDic:(NSDictionary*)dic{
    if(!dic){
        return;
    }
    [_refundStateArr removeAllObjects];
    RefundStateEntity *entity = [RefundStateEntity initRefundStateWithDic:dic];
    [_refundStateArr addObject:entity];
}

@end
