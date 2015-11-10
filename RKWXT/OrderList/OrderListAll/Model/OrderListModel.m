//
//  OrderListModel.m
//  RKWXT
//
//  Created by SHB on 15/7/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "OrderListModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "OrderListEntity.h"

@interface OrderListModel(){
    NSMutableArray *_oldOrderListArr;
    NSMutableArray *_orderListAll;
    NSMutableArray *_orderInfoArr;
    NSInteger fromIndexNum;
}
@end

@implementation OrderListModel

-(id)init{
    self = [super init];
    if(self){
        _oldOrderListArr = [[NSMutableArray alloc] init];
        _orderListAll = [[NSMutableArray alloc] init];
        _orderInfoArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)toInit{
    [super toInit];
    [_orderListAll removeAllObjects];
    [_oldOrderListArr removeAllObjects];
    [_orderInfoArr removeAllObjects];
}

+(OrderListModel*)shareOrderListModel{
    static dispatch_once_t onceToken;
    static OrderListModel *sharedInstance = nil;
    dispatch_once(&onceToken,^{
        sharedInstance = [[OrderListModel alloc] init];
    });
    return sharedInstance;
}

-(BOOL)shouldDataReload{
    return self.status == E_ModelDataStatus_Init || self.status == E_ModelDataStatus_LoadFailed;
}

#pragma mark 加载订单
-(void)loadUserOrderList:(NSInteger)fromIndex to:(NSInteger)toIndex{
    fromIndexNum = fromIndex;
    [self setStatus:E_ModelDataStatus_Loading];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.sellerID, @"seller_user_id", @"iOS", @"pid", [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.user], @"pwd", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:(int)kSubShopID], @"shop_id", [NSNumber numberWithInt:(int)fromIndex], @"start_item", [NSNumber numberWithInt:(int)toIndex], @"length", nil];
    __block OrderListModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_OrderList httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserOderList_LoadFailed object:retData.errorDesc];
        }else{
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
            [blockSelf parseOrderListData:retData.data];
        }
    }];
}

-(void)parseOrderListData:(NSDictionary*)dic1{
    if(!dic1){
        return;
    }
    if(_orderlist_type == OrderList_Type_Refresh || _orderlist_type == OrderList_Type_Normal){
        [_orderListAll removeAllObjects];
    }
    [_oldOrderListArr removeAllObjects];
    [_orderInfoArr removeAllObjects];
    NSDictionary *dic = [dic1 objectForKey:@"data"];
    NSArray *goodsArr = [dic objectForKey:@"order_goods"];
    for(NSDictionary *dictionary in goodsArr){
        OrderListEntity *entity = [OrderListEntity orderListDataWithDictionary:dictionary];
        [_oldOrderListArr addObject:entity];    //加载所有原始商品列表数据
    }
    NSArray *infoArr = [dic objectForKey:@"order_info"];
    for(NSDictionary *dictionary in infoArr){
        OrderListEntity *entity = [OrderListEntity orderInfoDataWithDictionary:dictionary];
        [_orderInfoArr addObject:entity];   //加载所有订单基本信息数据
    }
    [self cleanUpAllGoodsList];
}

-(void)cleanUpAllGoodsList{
    for(OrderListEntity *entity in _orderInfoArr){
        NSMutableArray *localArr = [[NSMutableArray alloc] init];
        for(OrderListEntity *ent in _oldOrderListArr){
            if(ent.order_id == entity.order_id){
                [localArr addObject:ent];
            }
        }
        entity.goodsArr = localArr;
        [_orderListAll addObject:entity];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserOderList_LoadSucceed object:nil];
}

#pragma mark 确认或取消订单
-(void)dealUserOrderListWithType:(DealOrderList_Type)type with:(NSString *)orderID{
    [self setStatus:E_ModelDataStatus_Loading];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.sellerID, @"seller_user_id", @"iOS", @"pid", [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.pwd], @"pwd", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", userObj.wxtID, @"woxin_id", orderID, @"order_id", [NSNumber numberWithInt:(int)type], @"type", nil];
    __block OrderListModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_DealOrderList httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            if(type == DealOrderList_Type_Cancel){
                [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserOderList_CancelFailed object:retData.errorDesc];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserOderList_CompleteFailed object:retData.errorDesc];
            }
        }else{
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
            if(type == DealOrderList_Type_Cancel){
                [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserOderList_CancelSucceed object:orderID];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserOderList_CompleteSucceed object:orderID];
            }
        }
    }];
}

#pragma mark refund
-(void)refundOrderWithRefundType:(Refund_Type)refundType withOrderGoodsID:(NSInteger)orderGoodsID orderID:(NSInteger)orderID withMessage:(NSString *)message{
    [self setStatus:E_ModelDataStatus_Loading];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.sellerID, @"seller_user_id", @"iOS", @"pid", [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.pwd], @"pwd", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:(int)orderID], @"order_id", [NSNumber numberWithInt:(int)refundType], @"type", message, @"apply_refund_cause", [NSNumber numberWithInt:(int)orderGoodsID], @"order_goods_id", nil];
    __block OrderListModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_Refund httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserOderList_RefundFailed object:retData.errorDesc];
        }else{
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
            [blockSelf parseRefundOrderSucceedWithOrderID:orderID withRefundType:refundType withOrderGoodsID:orderGoodsID];
        }
    }];
}

-(void)parseRefundOrderSucceedWithOrderID:(NSInteger)orderID withRefundType:(Refund_Type)refund_type withOrderGoodsID:(NSInteger)orderGoodsID{
    //退整个订单
    if(refund_type == Refund_Type_Order){
        for(OrderListEntity *entity in _orderListAll){
            if(entity.order_id == orderID){
                for(OrderListEntity *ent in entity.goodsArr){
                    ent.refund_status = Refund_Status_Being;
                }
            }
        }
    }
    //退单品
    if(refund_type == Refund_Type_Goods){
        for(OrderListEntity *entity in _orderListAll){
            if(entity.order_id == orderID){
                for(OrderListEntity *ent in entity.goodsArr){
                    if(ent.orderGoodsID == orderGoodsID){
                        ent.refund_status = Refund_Status_Being;
                    }
                }
            }
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserOderList_RefundSucceed object:nil];
    
}

@end
