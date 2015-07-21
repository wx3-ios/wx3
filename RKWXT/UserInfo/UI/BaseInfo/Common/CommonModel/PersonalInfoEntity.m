//
//  PersonalInfoEntity.m
//  RKWXT
//
//  Created by SHB on 15/7/20.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "PersonalInfoEntity.h"

@implementation PersonalInfoEntity

+(PersonalInfoEntity*)initWithPersonalInfoWith:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    if(self = [super init]){
        NSString *bir = [dic objectForKey:@"birthday"];
        [self setBirthday:bir];
        
        NSString *nick = [dic objectForKey:@"nickname"];
        [self setUserNickName:nick];
        
        NSInteger sex = [[dic objectForKey:@"sex"] integerValue];
        [self setBsex:sex];
    }
    return self;
}

@end
