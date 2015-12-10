//
//  JuniorListEntity.m
//  RKWXT
//
//  Created by SHB on 15/12/10.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "JuniorListEntity.h"

@implementation JuniorListEntity

+(JuniorListEntity*)initJuniorListEntity:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *name = [dic objectForKey:@"nickname"];
        [self setNickName:name];
        
        NSInteger clientNum = [[dic objectForKey:@"client_nums"] integerValue];
        [self setClientNums:clientNum];
        
        NSString *phone = [dic objectForKey:@"phone"];
        [self setPhone:phone];
        
        NSString *imgUrl = [dic objectForKey:@"pic"];
        [self setImgUrl:imgUrl];
        
        NSInteger wxID = [[dic objectForKey:@"woxin_id"] integerValue];
        [self setWxID:wxID];
    }
    return self;
}

@end
