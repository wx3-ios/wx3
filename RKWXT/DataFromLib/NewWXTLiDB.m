//
//  NewWXTLiDB.m
//  RKWXT
//
//  Created by SHB on 15/6/27.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "NewWXTLiDB.h"
#import "SCartListModel.h"
#import "UserAddressModel.h"
#import "UserBonusModel.h"

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
    [[SCartListModel shareShoppingCartModel] loadShoppingCartList];
    [[UserBonusModel shareUserBonusModel] loadUserBonus];
    [[UserAddressModel shareUserAddress] loadUserAddress];
}

@end
