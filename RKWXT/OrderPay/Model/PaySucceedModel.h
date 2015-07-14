//
//  PaySucceedModel.h
//  RKWXT
//
//  Created by SHB on 15/7/14.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

typedef enum{
    Pay_Type_AliPay = 0,
    Pay_Type_Weixin,
    Pay_Type_Union,
    
    Pay_Type_Invalid,
}Pay_Type;

@interface PaySucceedModel : T_HPSubBaseModel

+(PaySucceedModel*)sharePaySucceed;
-(void)updataPayOrder:(Pay_Type)type withOrderID:(NSInteger)orderID;

@end
