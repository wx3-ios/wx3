//
//  MyClientEntity.m
//  RKWXT
//
//  Created by SHB on 15/9/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "MyClientEntity.h"

@implementation MyClientEntity

+(MyClientEntity*)initMyClientPersonWithDic:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *nickName = [dic objectForKey:@"nickname"];
        [self setNickName:nickName];
        
        NSString *iconImg = [dic objectForKey:@"pic"];
        [self setUserIconImg:iconImg];
        
        NSInteger userid = [[dic objectForKey:@"woxin_id"] integerValue];
        [self setUserID:userid];
        
        NSString *userPhone = [dic objectForKey:@"phone"];
        [self setUserPhone:userPhone];
        
        CGFloat money = [[dic objectForKey:@"amount"] floatValue];
        [self setCutMoney:money];
        
        NSInteger time = [[dic objectForKey:@"register_time"] integerValue];
        [self setRegistTime:time];
    }
    return self;
}

@end
