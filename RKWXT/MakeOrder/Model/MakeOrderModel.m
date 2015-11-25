//
//  MakeOrderModel.m
//  RKWXT
//
//  Created by SHB on 15/6/26.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "MakeOrderModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "GoodsInfoEntity.h"
#import "NewUserAddressModel.h"
#import "AreaEntity.h"
#import "NSObject+SBJson.h"

@interface MakeOrderModel(){
    NSMutableArray *_dataList;
}
@end

@implementation MakeOrderModel
@synthesize data = _dataList;

-(void)toInit{
    [super toInit];
    [_dataList removeAllObjects];
}

-(id)init{
    self = [super init];
    if(self){
        _dataList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(BOOL)shouldDataReload{
    return self.status == E_ModelDataStatus_Init || self.status == E_ModelDataStatus_LoadFailed;
}

-(void)submitOneOrderWithAllMoney:(CGFloat)allMoney withTotalMoney:(CGFloat)totalMoney withRedPacket:(NSInteger)packet withRemark:(NSString *)remark withProID:(NSInteger)proID withCarriage:(CGFloat)postage withGoodsList:(NSArray *)goodsList{
    [self setStatus:E_ModelDataStatus_Loading];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    AreaEntity *entity = [self addressEntity];
    if(!entity){
        if (_delegate && [_delegate respondsToSelector:@selector(makeOrderFailed:)]){
            [_delegate makeOrderFailed:@"请设置收货信息"];
        }
        return;
    }
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@",entity.proName,entity.cityName,entity.disName,entity.address];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:    //dictionaryWithObjectsAndKeys此方法遇nil认为结束，慎用
                         userObj.sellerID, @"seller_user_id",
                         @"iOS", @"pid",
                         userObj.user, @"phone",
                         [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.pwd], @"pwd",
                         [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts",
                         [UtilTool currentVersion], @"ver",
                         [NSNumber numberWithInt:(int)kSubShopID], @"shop_id",
                         userObj.wxtID, @"woxin_id",
                         entity.userName, @"consignee",
                         entity.userPhone, @"telephone",
                         address, @"address",
                         [NSNumber numberWithInt:(int)kMerchantID], @"sid",
                         [NSNumber numberWithFloat:allMoney], @"order_total_money",
                         [NSNumber numberWithFloat:totalMoney], @"total_fee",
                         [NSNumber numberWithInt:(int)packet], @"red_packet",
                         [NSNumber numberWithFloat:postage], @"postage",
                         [NSNumber numberWithInt:(int)proID], @"provincial_id",
                         goodsList, @"goods",
                         remark, @"remark",
                         nil];
    __block MakeOrderModel *blockSelf = nil;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_NewMakeOrder httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            if (_delegate && [_delegate respondsToSelector:@selector(makeOrderFailed:)]){
                [_delegate makeOrderFailed:retData.errorDesc];
            }
        }else{
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
            _orderID = [[retData.data objectForKey:@"data"] objectForKey:@"order_id"];
            if (_delegate && [_delegate respondsToSelector:@selector(makeOrderSucceed)]){
                [_delegate makeOrderSucceed];
            }
        }
    }];
}

//限时购
-(void)submitLimitOrderWithAllMoney:(CGFloat)allMoney withTotalMoney:(CGFloat)totalMoney withRedPacket:(NSInteger)packet withRemark:(NSString*)remark withProID:(NSInteger)proID withCarriage:(CGFloat)postage withGoodsList:(NSArray*)goodsList{
    [self setStatus:E_ModelDataStatus_Loading];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    AreaEntity *entity = [self addressEntity];
    if(!entity){
        if (_delegate && [_delegate respondsToSelector:@selector(makeOrderFailed:)]){
            [_delegate makeOrderFailed:@"请设置收货信息"];
        }
        return;
    }
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@",entity.proName,entity.cityName,entity.disName,entity.address];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:    //dictionaryWithObjectsAndKeys此方法遇nil认为结束，慎用
                         userObj.sellerID, @"seller_user_id",
                         @"iOS", @"pid",
                         userObj.user, @"phone",
                         [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.pwd], @"pwd",
                         [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts",
                         [UtilTool currentVersion], @"ver",
                         [NSNumber numberWithInt:(int)kSubShopID], @"shop_id",
                         userObj.wxtID, @"woxin_id",
                         entity.userName, @"consignee",
                         entity.userPhone, @"telephone",
                         address, @"address",
                         [NSNumber numberWithInt:(int)kMerchantID], @"sid",
                         [NSNumber numberWithFloat:allMoney], @"order_total_money",
                         [NSNumber numberWithFloat:totalMoney], @"total_fee",
                         [NSNumber numberWithInt:(int)packet], @"red_packet",
                         [NSNumber numberWithFloat:postage], @"postage",
                         [NSNumber numberWithInt:(int)proID], @"provincial_id",
                         goodsList, @"goods",
                         remark, @"remark",
                         nil];
    __block MakeOrderModel *blockSelf = nil;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_LimitBuyMakeOrder httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            if (_delegate && [_delegate respondsToSelector:@selector(makeOrderFailed:)]){
                [_delegate makeOrderFailed:retData.errorDesc];
            }
        }else{
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
            _orderID = [[retData.data objectForKey:@"data"] objectForKey:@"order_id"];
            if (_delegate && [_delegate respondsToSelector:@selector(makeOrderSucceed)]){
                [_delegate makeOrderSucceed];
            }
        }
    }];
}

//暂时不用
-(NSArray*)changeTypeWithOldArr:(NSArray*)oldArr{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in oldArr){
        NSString *str = [dic JSONRepresentation];
        [arr addObject:str];
    }
    return arr;
}

-(AreaEntity *)addressEntity{
    if([[NewUserAddressModel shareUserAddress].userAddressArr count] == 0){
        return nil;
    }
    AreaEntity *entity = nil;
    for(AreaEntity *ent in [NewUserAddressModel shareUserAddress].userAddressArr){
        if(ent.normalID == 1){
            entity = ent;
        }
    }
    return entity;
}

@end
