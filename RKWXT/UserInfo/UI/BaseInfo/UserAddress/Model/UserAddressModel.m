//
//  UserAddressModel.m
//  RKWXT
//
//  Created by SHB on 15/6/25.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "UserAddressModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "AddressEntity.h"

@interface UserAddressModel(){
    NSMutableArray *_userAddressArr;
}
@end

@implementation UserAddressModel

+(UserAddressModel*)shareUserAddress{
    static dispatch_once_t onceToken;
    static UserAddressModel *sharedInstance = nil;
    dispatch_once(&onceToken,^{
        sharedInstance = [[UserAddressModel alloc] init];
    });
    return sharedInstance;
}

-(id)init{
    if(self = [super init]){
        _userAddressArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(BOOL)shouldDataReload{
    return self.status == E_ModelDataStatus_Init || self.status == E_ModelDataStatus_LoadFailed;
}

-(void)toInit{
    [super toInit];
    [_userAddressArr removeAllObjects];
}

//地址查询
-(void)loadUserAddress{
    [self setStatus:E_ModelDataStatus_Loading];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userObj.user, @"phone", [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.pwd], @"pwd", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:2], @"type", nil];
    __block UserAddressModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_NewMall_UserAddress httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserAddress_LoadDateFailed object:retData.errorDesc];
        }else{
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
            [blockSelf parseUserAddressList:[retData.data objectForKey:@"data"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserAddress_LoadDateSucceed object:nil];
        }
    }];
}

-(void)parseUserAddressList:(NSArray*)dicArr{
    if(!dicArr){
        return;
    }
    for(NSDictionary *dic1 in dicArr){
        AddressEntity *entity = [AddressEntity initAddressEntityWithDic:dic1];
        [_userAddressArr addObject:entity];
    }
}

//添加地址
-(void)insertUserAddressWithName:(NSString *)userName withAdd:(NSString *)address withPhone:(NSString *)phone{
    [self setStatus:E_ModelDataStatus_Loading];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userObj.user, @"phone", [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.pwd], @"pwd", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", userObj.wxtID, @"woxin_id", userName, @"consignee", phone, @"telephone", [NSNumber numberWithInt:1], @"type", address, @"address", nil];
    __block UserAddressModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_NewMall_UserAddress httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserAddress_InsertDataFailed object:retData.errorDesc];
        }else{
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
            
            AddressEntity *entity = [[AddressEntity alloc] init];
            entity.userName = userName;
            entity.userPhone = phone;
            entity.address = address;
            entity.address_id = [[retData.data objectForKey:@"data"] integerValue];
            [_userAddressArr addObject:entity];
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserAddress_InsertDataSucceed object:nil];
        }
    }];
}

//删除地址
-(void)deleteUserAddressWithAddressID:(NSInteger)addressID{
    [self setStatus:E_ModelDataStatus_Loading];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userObj.user, @"phone", [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.pwd], @"pwd", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:4], @"type", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:(int)addressID], @"address_id", nil];
    __block UserAddressModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_NewMall_UserAddress httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserAddress_DelDateFailed object:retData.errorDesc];
        }else{
            for(AddressEntity *entity in _userAddressArr){
                if(entity.address_id == addressID){
                    [_userAddressArr removeObject:entity];
                    break;
                }
            }
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserAddress_DelDateSucceed object:nil];
        }
    }];
}

//修改
-(void)modifyUserAddressWithName:(NSString *)userName withAdd:(NSString *)address withPhone:(NSString *)phone withID:(NSInteger)address_id{
    [self setStatus:E_ModelDataStatus_Loading];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userObj.user, @"phone", [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.pwd], @"pwd", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", userName, @"consignee", phone, @"telephone", [NSNumber numberWithInt:3], @"type", address, @"address", [NSNumber numberWithInt:(int)address_id], @"address_id", userObj.wxtID, @"woxin_id", nil];
    __block UserAddressModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_NewMall_UserAddress httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserAddress_InsertDataFailed object:retData.errorDesc];
        }else{
            for(AddressEntity *entity in _userAddressArr){
                if(entity.address_id == address_id){
                    entity.userName = userName;
                    entity.userPhone = phone;
                    entity.address = address;
                    break;
                }
            }
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserAddress_InsertDataSucceed object:nil];
        }
    }];
}

//设置默认地址
-(void)setNormalAddressWithOldAddID:(NSInteger)oldAddID withNewAddID:(NSInteger)newAddID{
    [self setStatus:E_ModelDataStatus_Loading];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userObj.user, @"phone", [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.pwd], @"pwd", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:5], @"type", [NSNumber numberWithInt:(int)oldAddID], @"old_address_id", [NSNumber numberWithInt:(int)newAddID], @"new_address_id", userObj.wxtID, @"woxin_id", nil];
    __block UserAddressModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_NewMall_UserAddress httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserAddress_DelDateFailed object:retData.errorDesc];
        }else{
            for(AddressEntity *entity in _userAddressArr){
                if(entity.address_id == newAddID){
                    entity.normalID = 1;
                }else{
                    entity.normalID = 0;
                }
            }
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserAddress_DelDateSucceed object:nil];
        }
    }];
}

@end
