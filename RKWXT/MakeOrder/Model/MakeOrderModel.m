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

/*
 接口名称：下订单接口
 接口地址：https://oldyun.67call.com/wx3api/insert_order3.php
 请求方式：POST
 输入参数：
	pid:平台类型(android,ios,web),
	ver:版本号,
	ts:时间戳,
	woxin_id:我信ID，
	shop_id:店铺ID，
	phone:手机号,
	consignee：联系人姓名
 
	address: 联系人地址
	telephone：联系人电话
 
	order_total_money：订单总金额
	total_fee：实际支付总金额
	red_packet：使用红包金额
 
	goods_info : 库存ID:数量^库存ID:数量^库存ID:数量  11232:3^10931:1^23832:2   goods_stock_id:number
	action_type : 0.无活动 1.包邮  2.满减
	remark：备注
      满减 full_reduce
    provincial_id: 省份ID
 
 返回数据格式：json
 成功返回: error ：0  data:数据
 失败返回：error ：1  msg:错误信息
 
 action_type：
 
 0.可以使用红包，需计算邮费，不能满减
 1.不计算邮费，不可以使用红包，不能满减
 2.满减，需计算邮费，不能使用红包
 
 order_total_money ： 商品价格*数量+邮费
 total_fee ： order_total_money-红包/满减
 */

- (void)submitNewOrderWithAllMoney:(CGFloat)allMoney withTotalMoney:(CGFloat)totalMoney withRedPacket:(NSInteger)packet withRemark:(NSString*)remark withProID:(NSInteger)proID withCarriage:(CGFloat)postage withGoodsList:(NSString*)goodsList type:(NSInteger)type{
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
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pid"] = @"ios";
    dic[@"ver"] = [UtilTool currentVersion];
    dic[@"ts"] = [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    dic[@"woxin_id"] = userObj.wxtID;
    dic[@"sid"] = [NSNumber numberWithInteger:kMerchantID];
    dic[@"shop_id"] = [NSNumber numberWithInt:(int)kSubShopID];
    dic[@"phone"] = userObj.user;
    dic[@"consignee"] = entity.userName;
    dic[@"provincial_id"] = [NSNumber numberWithInteger:proID];
    dic[@"address"] = address;
    dic[@"telephone"] = entity.userPhone;
    
    dic[@"order_total_money"] = [NSNumber numberWithFloat:allMoney];
    dic[@"total_fee"] = [NSNumber numberWithFloat:totalMoney];
    dic[@"red_packet"] = [NSNumber numberWithInt:(int)packet];
  
    dic[@"goods_info"] = goodsList;
    dic[@"action_type"] = [NSNumber numberWithInteger:type];
    dic[@"remark"] = remark;
    
    dic[@"postage"] = [NSNumber numberWithFloat:postage];
    NSLog(@"%@",dic);
    
    __block MakeOrderModel *blockSelf = nil;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_NewTooMakeOrder httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
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
    NSLog(@"%@",dic);
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
