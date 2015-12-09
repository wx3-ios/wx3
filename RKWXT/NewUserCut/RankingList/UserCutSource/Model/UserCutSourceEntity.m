//
//  UserCutSourceEntity.m
//  RKWXT
//
//  Created by SHB on 15/12/8.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "UserCutSourceEntity.h"

@implementation UserCutSourceEntity

+(UserCutSourceEntity*)initUserCutSourceEntityWith:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWidthDic:dic];
}

-(id)initWidthDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *name = [dic objectForKey:@"nickname"];
        [self setNickName:name];
        
        NSString *phone = [dic objectForKey:@"phone"];
        [self setPhone:phone];
        
        NSString *imgUrl = [dic objectForKey:@"pic"];
        [self setImgUrl:imgUrl];
        
        NSString *time = [dic objectForKey:@"register_time"];
        [self setRegisterTime:time];
        
        CGFloat money = [[dic objectForKey:@"total_money"] floatValue];
        [self setMoney:money];
        
        NSInteger wxID = [[dic objectForKey:@"woxin_id"] integerValue];
        [self setWxID:wxID];
    }
    return self;
}

@end
