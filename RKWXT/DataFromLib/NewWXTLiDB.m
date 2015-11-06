//
//  NewWXTLiDB.m
//  RKWXT
//
//  Created by SHB on 15/6/27.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "NewWXTLiDB.h"
#import "SCartListModel.h"
#import "NewUserAddressModel.h"
#import "UserBonusModel.h"
#import "OrderListModel.h"
#import "UserHeaderModel.h"

@implementation NewWXTLiDB

+(NewWXTLiDB*)sharedWXLibDB{
    static dispatch_once_t onceToken;
    static NewWXTLiDB *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NewWXTLiDB alloc] init];
    });
    return sharedInstance;
}

-(void)loadData{
//    [[SCartListModel shareShoppingCartModel] loadShoppingCartList];
    [[UserBonusModel shareUserBonusModel] loadUserBonus];
    [[UserBonusModel shareUserBonusModel] loadUserBonusMoney];
    [NewUserAddressModel shareUserAddress].address_type = UserAddress_Type_Search;
    [[NewUserAddressModel shareUserAddress] loadUserAddress];
    [[OrderListModel shareOrderListModel] loadUserOrderList:0 to:5];
    [[UserHeaderModel shareUserHeaderModel] loadUserHeaderImageWith];
}

@end
