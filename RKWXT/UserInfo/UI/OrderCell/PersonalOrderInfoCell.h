//
//  PersonalOrderInfoCell.h
//  RKWXT
//
//  Created by SHB on 15/6/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTUITableViewCell.h"

#define PersonalOrderInfoCellHeight (53)

@protocol PersonalOrderInfoDelegate;

@interface PersonalOrderInfoCell : WXTUITableViewCell
@property (nonatomic,assign) id<PersonalOrderInfoDelegate>delegate;
@end

@protocol PersonalOrderInfoDelegate <NSObject>
-(void)personalInfoToShoppingCart;
-(void)personalInfoToWaitPayOrderList;
-(void)personalInfoToWaitReceiveOrderList;

@end
