//
//  UserAliEntity.h
//  RKWXT
//
//  Created by SHB on 15/9/28.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    UserAliCount_Type_None = -1,
    UserAliCount_Type_Submit,
    UserAliCount_Type_Succeed,
    UserAliCount_Type_Failed,
}UserAliCount_Type;

@interface UserAliEntity : NSObject
@property (nonatomic,assign) UserAliCount_Type userali_type;
@property (nonatomic,strong) NSString *aliCount;
@property (nonatomic,strong) NSString *aliName;
@property (nonatomic,strong) NSString *refuseMsg;

+(UserAliEntity*)initUserAliAcountWithDic:(NSDictionary*)dic;

@end
