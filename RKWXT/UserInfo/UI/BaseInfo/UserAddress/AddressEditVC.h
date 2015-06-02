//
//  AddressEditVC.h
//  RKWXT
//
//  Created by SHB on 15/6/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUIViewController.h"
#import "AddressEntity.h"

#define AddressSqliteHasChanged @"AddressSqliteHasChanged"

@interface AddressEditVC : WXUIViewController
@property (nonatomic,strong) AddressEntity *entity;

@end
