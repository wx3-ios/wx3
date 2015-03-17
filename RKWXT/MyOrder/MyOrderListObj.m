//
//  MyOrderListObj.m
//  Woxin2.0
//
//  Created by qq on 14-8-12.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import "MyOrderListObj.h"
#import "it_lib.h"
#import "ServiceCommon.h"
#import "NSObject+SBJson.h"
#import "OrderListEntity.h"

@interface MyOrderListObj(){
    NSMutableArray *_orderListArr;
    NSMutableArray *_oldOrderListArr;
}
@end

@implementation MyOrderListObj
@synthesize orderListArr = _orderListArr;

-(void)dealloc{
    RELEASE_SAFELY(_orderListArr);
    RELEASE_SAFELY(_oldOrderListArr);
    [self removeOBS];
    [super dealloc];
}

+ (MyOrderListObj *)sharedOrderList{
    static dispatch_once_t onceToken;
    static MyOrderListObj *sharedOrderList = nil;
    dispatch_once(&onceToken, ^{
        sharedOrderList = [[MyOrderListObj alloc] init];
    });
    return sharedOrderList;
}

-(id)init{
    if(self = [super init]){
        _orderListArr = [[NSMutableArray alloc] init];
        _oldOrderListArr = [[NSMutableArray alloc] init];
        [self addOBS];
    }
    return self;
}

-(BOOL)isLoadOrderList{
    BOOL isLoad = NO;
    if([_orderListArr count] > 0){
        isLoad = YES;
    }
    return isLoad;
}

-(void)removeOrderList{
    [_orderListArr removeAllObjects];
}

//加载订单列表
-(void)loadOrderList{
    WXUserOBJ *userOBJ = [WXUserOBJ sharedUserOBJ];
    SS_UINT32 ret = IT_MallLoadOrderIND((SS_UINT32)userOBJ.subShopID,(SS_UINT32)1,(SS_UINT32)2);
    if(ret != 0){
        NSLog(@"加载订单列表 ret = %d",ret);
    }else{
        NSLog(@"加载订单列表成功");
    }
}

- (void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(loadOrderLsitSucceed:) name:D_Notification_Name_Lib_LoadOrderListSucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(loadOrderListFailed:) name:D_Notification_Name_Lib_LoadOrderListFailed object:nil];
}

- (void)loadOrderLsitSucceed:(NSNotification *)notification{
    [_orderListArr removeAllObjects];
    [_oldOrderListArr removeAllObjects];
    NSMutableArray *arr = [[[NSMutableArray alloc] init] autorelease];
    NSString *jsonString = notification.object;
    if(jsonString){
        NSArray *orderListArr = [[jsonString JSONValue] objectForKey:@"order"];
        for(NSDictionary *dic in orderListArr){
            OrderListEntity *orderEntity = [OrderListEntity orderListWithDictionary:dic];
            if(orderEntity){
                [arr addObject:orderEntity];
                [_oldOrderListArr addObject:orderEntity];
            }
        }
    }
    [self changeRechargeRuleTurn:arr];
    [[NSNotificationCenter defaultCenter] postNotificationName:loadMyOrderListSucceed object:nil];
}

-(void)changeRechargeRuleTurn:(NSMutableArray *)oldArr{
    NSInteger order_id = 100000;
    for(OrderListEntity *entity in oldArr){
        if([entity.order_id integerValue] > order_id){
            order_id = [entity.order_id integerValue];
        }
    }
    for(OrderListEntity *entity in _oldOrderListArr){
        if([entity.order_id integerValue] == order_id){
            [oldArr removeObject:entity];
            [_orderListArr addObject:entity];
        }
    }
    if([oldArr count] > 0){
        [self changeRechargeRuleTurn:oldArr];
    }
}

-(void)loadOrderListFailed:(NSNotification*)notification{
    [[NSNotificationCenter defaultCenter] postNotificationName:loadMyOrderListFailed object:nil];
}

- (void)removeOBS{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
