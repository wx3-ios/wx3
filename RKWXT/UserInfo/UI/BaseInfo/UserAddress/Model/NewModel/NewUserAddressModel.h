//
//  NewUserAddressModel.h
//  RKWXT
//
//  Created by SHB on 15/11/6.
//  Copyright © 2015年 roderick. All rights reserved.
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

typedef enum{
    UserAddress_Type_Insert = 1,
    UserAddress_Type_Search,
    UserAddress_Type_Change,
    UserAddress_Type_Delete,
    UserAddress_Type_Normal,
}UserAddress_Type;

@interface NewUserAddressModel : T_HPSubBaseModel
@property (nonatomic,assign) UserAddress_Type address_type;
@property (nonatomic,strong) NSArray *userAddressArr;

+(NewUserAddressModel*)shareUserAddress;
-(BOOL)shouldDataReload;
-(void)loadUserAddress;
-(void)insertUserAddressWithName:(NSString*)userName withAdd:(NSString*)address withPhone:(NSString*)phone proID:(NSInteger)proID cityID:(NSInteger)cityID disID:(NSInteger)disID proName:(NSString*)proName cityName:(NSString*)cityName disName:(NSString *)disName;
-(void)deleteUserAddressWithAddressID:(NSInteger)addressID;
-(void)modifyUserAddressWithName:(NSString*)userName withAdd:(NSString*)address withPhone:(NSString*)phone proID:(NSInteger)proID cityID:(NSInteger)cityID disID:(NSInteger)disID proName:(NSString*)proName cityName:(NSString*)cityName disName:(NSString *)disName addressID:(NSInteger)addressID;
-(void)setNormalAddressWithOldAddID:(NSInteger)oldAddID withNewAddID:(NSInteger)newAddID;

@end
