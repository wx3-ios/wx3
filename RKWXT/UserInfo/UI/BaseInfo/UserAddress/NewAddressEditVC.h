//
//  NewAddressEditVC.h
//  RKWXT
//
//  Created by SHB on 15/11/4.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUIViewController.h"
#import "AddressEntity.h"

typedef enum{
    NewAddress_Type_Insert = 0,
    NewAddress_Type_Modify,
    
    NewAddress_Type_Invalid
}NewAddress_Type;

@interface NewAddressEditVC : WXUIViewController
@property (nonatomic,assign) NewAddress_Type address_type;
@property (nonatomic,strong) AddressEntity *entity;

@end
