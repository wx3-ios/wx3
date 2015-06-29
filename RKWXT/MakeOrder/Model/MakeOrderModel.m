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
#import "UserAddressModel.h"
#import "AddressEntity.h"
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

-(void)submitOneOrderWithAllMoney:(CGFloat)allMoney withTotalMoney:(CGFloat)totalMoney withRedPacket:(NSInteger)packet withRemark:(NSString *)remark withGoodsList:(NSArray *)goodsList{
    [self setStatus:E_ModelDataStatus_Loading];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    AddressEntity *entity = [self addressEntity];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:    //dictionaryWithObjectsAndKeys此方法遇nil认为结束，慎用
                         @"iOS", @"pid",
                         @"18613213051", @"phone",
                         [UtilTool newStringWithAddSomeStr:5 withOldStr:@"123456"], @"pwd",
                         [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts",
                         [UtilTool currentVersion], @"ver",
                         [NSNumber numberWithInt:(int)kSubShopID], @"shop_id",
                         userObj.wxtID, @"woxin_id",
                         entity.userName, @"consignee",
                         entity.userPhone, @"telephone",
                         entity.address, @"address",
                         [NSNumber numberWithFloat:allMoney], @"order_total_money",
                         [NSNumber numberWithFloat:totalMoney], @"total_fee",
                         [NSNumber numberWithInt:(int)packet], @"red_packet",
                         goodsList, @"goods",
                         remark, @"remark",
                         nil];
    __block MakeOrderModel *blockSelf = nil;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_NewMall_MakeOrder httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            if (_delegate && [_delegate respondsToSelector:@selector(makeOrderFailed:)]){
                [_delegate makeOrderFailed:retData.errorDesc];
            }
        }else{
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
//            [blockSelf parseGoodInfoDetail:retData.data];
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

-(AddressEntity *)addressEntity{
    AddressEntity *entity = nil;
    for(AddressEntity *ent in [UserAddressModel shareUserAddress].userAddressArr){
        if(ent.normalID == 1){
            entity = ent;
        }
    }
    return entity;
}

@end
