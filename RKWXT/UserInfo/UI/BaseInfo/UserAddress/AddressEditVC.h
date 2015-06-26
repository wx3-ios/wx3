//
//  AddressEditVC.h
//  RKWXT
//
//  Created by SHB on 15/6/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUIViewController.h"
#import "AddressEntity.h"

typedef enum{
    Address_Type_Insert = 0,
    Address_Type_Modify,
    
    Address_Type_Invalid
}Address_Type;

@interface AddressEditVC : WXUIViewController
@property (nonatomic,assign) Address_Type address_type;
@property (nonatomic,strong) AddressEntity *entity;

@end
