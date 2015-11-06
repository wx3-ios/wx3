//
//  LuckyGoodsMakeOrderModel.m
//  RKWXT
//
//  Created by SHB on 15/8/18.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckyGoodsMakeOrderModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "NewUserAddressModel.h"
#import "AreaEntity.h"

@interface LuckyGoodsMakeOrderModel(){
}

@end

@implementation LuckyGoodsMakeOrderModel

-(id)init{
    self = [super init];
    if(self){
        
    }
    return self;
}

-(void)luckyGoodsMakeOrderWith:(NSInteger)lottery_id withGoodsID:(NSInteger)goods_id withName:(NSString *)goods_name withImgUrl:(NSString *)imgUrl withGoodsStockID:(NSInteger)stockID withStockName:(NSString *)stockName WithMoney:(CGFloat)money withMarket:(CGFloat)marketPrice{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    AreaEntity *entity = [self addressEntity];
    if(!entity){
        if (_delegate && [_delegate respondsToSelector:@selector(luckyGoodsMakeOrderFailed:)]){
            [_delegate luckyGoodsMakeOrderFailed:@"请设置收货信息"];
        }
        return;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.user, @"phone", [NSNumber numberWithInteger:lottery_id], @"lottery_id", userObj.wxtID, @"woxin_id", [NSNumber numberWithInteger:goods_id], @"goods_id", goods_name, @"goods_name", imgUrl, @"goods_img", [NSNumber numberWithInteger:stockID], @"goods_stock_id", stockName, @"goods_stock_name", [NSNumber numberWithFloat:money], @"total_fee", entity.address, @"address", entity.userName, @"consignee", entity.userPhone, @"telephone", [NSNumber numberWithFloat:marketPrice], @"market_price", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_LuckyMakeOrder httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(luckyGoodsMakeOrderFailed:)]){
                [_delegate luckyGoodsMakeOrderFailed:retData.errorDesc];
            }
        }else{
            [self setOrderID:[[retData.data objectForKey:@"data"] objectForKey:@"order_id"]];
            if(_delegate && [_delegate respondsToSelector:@selector(luckyGoodsMakeOrderSucceed)]){
                [_delegate luckyGoodsMakeOrderSucceed];
            }
        }
    }];
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
