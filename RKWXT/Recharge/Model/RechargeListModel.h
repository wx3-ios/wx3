//
//  RechargeListModel.h
//  RKWXT
//
//  Created by SHB on 15/8/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

@protocol RechargeListDelegate;
@interface RechargeListModel : NSObject
@property (nonatomic,assign) id<RechargeListDelegate>delegate;
@property (nonatomic,strong) NSString *orderID;
-(void)rechargeListWithMoney:(NSInteger)money;

@end

@protocol RechargeListDelegate <NSObject>
-(void)rechargeListSucceed;
-(void)rechargeListFailed:(NSString*)errorMsg;

@end
