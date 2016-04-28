//
//  UserAliEntity.m
//  RKWXT
//
//  Created by SHB on 15/9/28.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "UserAliEntity.h"

@implementation UserAliEntity

+(UserAliEntity*)initUserAliAcountWithDic:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *account = [dic objectForKey:@"account"];
        [self setAliCount:account];
        
        NSString *name = [dic objectForKey:@"username"];
        [self setAliName:name];
        
        NSInteger isOk = [[dic objectForKey:@"validate"] integerValue];
        [self setUserali_type:isOk];
        
        if(isOk == UserAliCount_Type_Failed){
            [self setRefuseMsg:[dic objectForKey:@"refusal_cause"]];
        }
    }
    return self;
}

@end
