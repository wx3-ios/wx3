//
//  AddressManagerCell.h
//  RKWXT
//
//  Created by SHB on 15/6/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"
@class AddressEntity;
#define AddressManagerCellHeight (39)

@protocol AddressManagerDelegate;
@interface AddressManagerCell : WXUITableViewCell
@property (nonatomic,assign) id<AddressManagerDelegate>delegate;
@end

@protocol AddressManagerDelegate <NSObject>
-(void)setAddressNormal:(AddressEntity*)entity;
-(void)editAddressInfo:(AddressEntity*)entity;
-(void)delAddress:(AddressEntity*)entity;

@end
