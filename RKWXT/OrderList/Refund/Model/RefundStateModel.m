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

-(void)loadRefundState{
    [self setStatus:E_ModelDataStatus_Loading];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"", @"", nil];
    __block RefundStateModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_Refund httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            if(_delegate && [_delegate respondsToSelector:@selector(loadRefundStateFailed:)]){
                [_delegate loadRefundStateFailed:retData.errorDesc];
            }
        }else{
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
            [blockSelf parseRefundStateWithDic:retData.data];
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
