//
//  MyRefereeEntity.m
//  RKWXT
//
//  Created by SHB on 15/9/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "MyRefereeEntity.h"

@implementation MyRefereeEntity

+(MyRefereeEntity*)initRefereeEntityWithDic:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        CGFloat money = [[dic objectForKey:@"gain_total_amount"] floatValue];
        [self setCutMoney:money];
        
        CGFloat allMoney = [[dic objectForKey:@"contribute_total_amount"] floatValue];
        [self setAllMoney:allMoney];
        
        id parent = [dic objectForKey:@"parent_1"];
        if([parent isKindOfClass:[NSString class]]){
        }
        
        if([parent isKindOfClass:[NSDictionary class]]){
            NSString *nickName = [parent objectForKey:@"nickname"];
            [self setNickName:nickName];
            
            NSString *iconImg = [parent objectForKey:@"pic"];
            [self setUserIconImg:iconImg];
            
            NSInteger userid = [[parent objectForKey:@"woxin_id"] integerValue];
            [self setUserID:userid];
            
            NSString *userPhone = [parent objectForKey:@"phone"];
            [self setUserPhone:userPhone];
            
            NSInteger time = [[parent objectForKey:@"register_time"] integerValue];
            [self setRegistTime:time];
        }
    }
    return self;
}

@end
