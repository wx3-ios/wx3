//
//  UserAddressModel.h
//  RKWXT
//
//  Created by SHB on 15/6/25.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

#define K_Notification_UserAddress_InsertDataSucceed @"K_Notification_UserAddress_InsertDataSucceed"   //插入地址
#define K_Notification_UserAddress_InsertDataFailed  @"K_Notification_UserAddress_InsertDataFailed"
#define K_Notification_UserAddress_LoadDateSucceed   @"K_Notification_UserAddress_LoadDateSucceed"     //查询
#define K_Notification_UserAddress_LoadDateFailed    @"K_Notification_UserAddress_LoadDateFailed"
#define K_Notification_UserAddress_DelDateSucceed    @"K_Notification_UserAddress_DelDateSucceed"      //删除
#define K_Notification_UserAddress_DelDateFailed     @"K_Notification_UserAddress_DelDateFailed"
#define K_Notification_UserAddress_ModifyDateSucceed @"K_Notification_UserAddress_ModifyDateSucceed"   //修改
#define K_Notification_UserAddress_ModifyDateFailed  @"K_Notification_UserAddress_ModifyDateFailed"
#define K_Notification_UserAddress_SetNorAddSucceed  @"K_Notification_UserAddress_SetNorAddSucceed"    //设置默认地址
#define K_Notification_UserAddress_SetNorAddFailed   @"K_Notification_UserAddress_SetNorAddFailed"

@interface UserAddressModel : T_HPSubBaseModel
@property (nonatomic,strong) NSArray *userAddressArr;

+(UserAddressModel*)shareUserAddress;
-(BOOL)shouldDataReload;
-(void)loadUserAddress;
-(void)insertUserAddressWithName:(NSString*)userName withAdd:(NSString*)address withPhone:(NSString*)phone;
-(void)deleteUserAddressWithAddressID:(NSInteger)addressID;
-(void)modifyUserAddressWithName:(NSString*)userName withAdd:(NSString*)address withPhone:(NSString*)phone withID:(NSInteger)address_id;
-(void)setNormalAddressWithOldAddID:(NSInteger)oldAddID withNewAddID:(NSInteger)newAddID;

@end
