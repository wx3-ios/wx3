//
//  AddressEntity.h
//  RKWXT
//
//  Created by SHB on 15/6/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressEntity : NSObject
//@property (nonatomic,strong) NSString *userName;
//@property (nonatomic,strong) NSString *userPhone;
//@property (nonatomic,strong) NSString *address;
//@property (nonatomic,assign) NSInteger address_id;
//@property (nonatomic,assign) NSInteger normalID;

@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *userPhone;
@property (nonatomic,strong) NSString *userProvince;
@property (nonatomic,strong) NSString *userCity;
@property (nonatomic,strong) NSString *userArea;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,assign) NSInteger provinceID;
@property (nonatomic,assign) NSInteger cityID;
@property (nonatomic,assign) NSInteger areaID;
@property (nonatomic,assign) NSInteger addressID;
@property (nonatomic,assign) NSInteger normalID;

+(AddressEntity*)initAddressEntityWithDic:(NSDictionary*)dic;

@end
