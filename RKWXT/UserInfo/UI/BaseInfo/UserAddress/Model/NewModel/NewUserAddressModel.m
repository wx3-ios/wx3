//
//  NewUserAddressModel.m
//  RKWXT
//
//  Created by SHB on 15/11/6.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "NewUserAddressModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "AreaEntity.h"

@interface NewUserAddressModel(){
    NSMutableArray *_userAddressArr;
}
@end

@implementation NewUserAddressModel

+(NewUserAddressModel*)shareUserAddress{
    static dispatch_once_t onceToken;
    static NewUserAddressModel *sharedInstance = nil;
    dispatch_once(&onceToken,^{
        sharedInstance = [[NewUserAddressModel alloc] init];
    });
    return sharedInstance;
}

-(id)init{
    if(self = [super init]){
        _userAddressArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)toInit{
    self.status = E_ModelDataStatus_Init;
    [_userAddressArr removeAllObjects];
}

-(BOOL)shouldDataReload{
    return self.status == E_ModelDataStatus_Init || self.status == E_ModelDataStatus_LoadFailed;
}

//地址查询
-(void)loadUserAddress{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.pwd], @"pwd", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:_address_type], @"type", userObj.user, @"phone", nil];
    __block NewUserAddressModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_NewMall_NewUserAddress httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserAddress_LoadDateFailed object:retData.errorDesc];
        }else{
            [blockSelf parseUserAddressList:[retData.data objectForKey:@"data"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserAddress_LoadDateSucceed object:nil];
        }
    }];
}

-(void)parseUserAddressList:(NSArray*)dicArr{
    if(!dicArr){
        return;
    }
    [_userAddressArr removeAllObjects];
    for(NSDictionary *dic1 in dicArr){
        AreaEntity *entity = [AreaEntity initAreaEntityWith:dic1];
        [_userAddressArr addObject:entity];
    }
}

//添加地址
-(void)insertUserAddressWithName:(NSString *)userName withAdd:(NSString *)address withPhone:(NSString *)phone proID:(NSInteger)proID cityID:(NSInteger)cityID disID:(NSInteger)disID proName:(NSString *)proName cityName:(NSString *)cityName disName:(NSString *)disName{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.pwd], @"pwd", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", userObj.wxtID, @"woxin_id", userName, @"consignee", phone, @"telephone", [NSNumber numberWithInt:_address_type], @"type", address, @"address", [NSNumber numberWithInt:proID],@"provincial_id", [NSNumber numberWithInt:cityID], @"municipality_id", [NSNumber numberWithInt:disID], @"county_id", proName, @"provincial", cityName, @"municipality", disName, @"county", userObj.user, @"phone", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_NewMall_NewUserAddress httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserAddress_InsertDataFailed object:retData.errorDesc];
        }else{
            AreaEntity *entity = [[AreaEntity alloc] init];
            entity.userName = userName;
            entity.userPhone = phone;
            entity.address = address;
            entity.proName = proName;
            entity.cityName = cityName;
            entity.disName = disName;
            entity.proID = proID;
            entity.cityID = cityID;
            entity.disID = disID;
            if([_userAddressArr count] == 0){
                entity.normalID = 1;
            }
            [_userAddressArr addObject:entity];
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserAddress_InsertDataSucceed object:nil];
        }
    }];
}

//删除地址
-(void)deleteUserAddressWithAddressID:(NSInteger)addressID{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userObj.user, @"phone", [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.pwd], @"pwd", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:_address_type], @"type", [NSNumber numberWithInt:(int)addressID], @"address_id", userObj.wxtID, @"woxin_id", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_NewMall_NewUserAddress httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserAddress_DelDateFailed object:retData.errorDesc];
        }else{
            for(AreaEntity *entity in _userAddressArr){
                if(entity.address_id == addressID){
                    [_userAddressArr removeObject:entity];
                    break;
                }
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserAddress_DelDateSucceed object:nil];
        }
    }];
}

//修改
-(void)modifyUserAddressWithName:(NSString *)userName withAdd:(NSString *)address withPhone:(NSString *)phone proID:(NSInteger)proID cityID:(NSInteger)cityID disID:(NSInteger)disID proName:(NSString *)proName cityName:(NSString *)cityName disName:(NSString *)disName addressID:(NSInteger)addressID{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.pwd], @"pwd", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", userObj.wxtID, @"woxin_id", userName, @"consignee", phone, @"telephone", [NSNumber numberWithInt:_address_type], @"type", address, @"address", [NSNumber numberWithInt:proID],@"provincial_id", [NSNumber numberWithInt:cityID], @"municipality_id", [NSNumber numberWithInt:disID], @"county_id", proName, @"provincial", cityName, @"municipality", disName, @"county", userObj.user, @"phone", [NSNumber numberWithInt:addressID], @"address_id", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_NewMall_NewUserAddress httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserAddress_InsertDataFailed object:retData.errorDesc];
        }else{
            for(AreaEntity *entity in _userAddressArr){
                if(entity.address_id == addressID){
                    entity.userName = userName;
                    entity.userPhone = phone;
                    entity.address = address;
                    entity.proName = proName;
                    entity.cityName = cityName;
                    entity.disName = disName;
                    entity.proID = proID;
                    entity.cityID = cityID;
                    entity.disID = disID;
                    break;
                }
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserAddress_InsertDataSucceed object:nil];
        }
    }];
}

//设置默认地址
-(void)setNormalAddressWithOldAddID:(NSInteger)oldAddID withNewAddID:(NSInteger)newAddID{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userObj.user, @"phone", [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.pwd], @"pwd", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:_address_type], @"type", [NSNumber numberWithInt:(int)newAddID], @"address_id", userObj.wxtID, @"woxin_id", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_NewMall_NewUserAddress httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserAddress_DelDateFailed object:retData.errorDesc];
        }else{
            for(AreaEntity *entity in _userAddressArr){
                if(entity.address_id == newAddID){
                    entity.normalID = 1;
                }else{
                    entity.normalID = 0;
                }
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserAddress_DelDateSucceed object:nil];
        }
    }];
}

@end
