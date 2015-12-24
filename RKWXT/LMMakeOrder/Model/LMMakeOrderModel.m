//
//  LMMakeOrderModel.m
//  RKWXT
//
//  Created by SHB on 15/12/21.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMMakeOrderModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "LMGoodsInfoEntity.h"
#import "NewUserAddressModel.h"
#import "AreaEntity.h"
#import "NSObject+SBJson.h"

@implementation LMMakeOrderModel

-(void)submitOneOrderWithAllMoney:(CGFloat)allMoney withTotalMoney:(CGFloat)totalMoney withRedPacket:(NSInteger)packet withRemark:(NSString *)remark withProID:(NSInteger)proID withCarriage:(CGFloat)postage withGoodsList:(NSArray *)goodsList shopID:(NSInteger)shopID{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    AreaEntity *entity = [self addressEntity];
    if(!entity){
        if (_delegate && [_delegate respondsToSelector:@selector(lmMakeOrderFailed:)]){
            [_delegate lmMakeOrderFailed:@"请设置收货信息"];
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
                         [NSNumber numberWithInteger:shopID], @"shop_id",
                         userObj.wxtID, @"woxin_id",
                         entity.userName, @"consignee",
                         entity.userPhone, @"telephone",
                         address, @"address",
                         [NSNumber numberWithInteger:kMerchantID], @"seller_id",
                         [NSNumber numberWithFloat:allMoney], @"order_total_money",
                         [NSNumber numberWithFloat:totalMoney], @"total_fee",
                         [NSNumber numberWithInt:(int)packet], @"red_packet",
                         [NSNumber numberWithFloat:postage], @"postage",
                         [NSNumber numberWithInt:(int)proID], @"provincial_id",
                         goodsList, @"goods",
                         remark, @"remark",
                         nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_Home_LMMakeOrder httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            if (_delegate && [_delegate respondsToSelector:@selector(lmMakeOrderFailed:)]){
                [_delegate lmMakeOrderFailed:retData.errorDesc];
            }
        }else{
            _lmOrderID = [[retData.data objectForKey:@"data"] objectForKey:@"order_id"];
            if (_delegate && [_delegate respondsToSelector:@selector(lmMakeOrderSucceed)]){
                [_delegate lmMakeOrderSucceed];
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
