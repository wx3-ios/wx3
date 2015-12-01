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
        
        if([[dic objectForKey:@"balance"] isKindOfClass:[NSString class]]){
            CGFloat balance = [[dic objectForKey:@"balance"] floatValue];
            [self setBalance:balance];
        }else{
            [self setBalance:0];
        }
        
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
        
        id subnumber = [dic objectForKey:@"subnumber"];
        if([subnumber isKindOfClass:[NSDictionary class]]){
            NSInteger parent_1 = [[subnumber objectForKey:@"parent_1n"] integerValue];
            [self setParent_1:parent_1];
            
            NSInteger parent_2 = [[subnumber objectForKey:@"parent_2n"] integerValue];
            [self setParent_2:parent_2];
            
            NSInteger parent_3 = [[subnumber objectForKey:@"parent_3n"] integerValue];
            [self setParent_3:parent_3];
        }
    }
    return self;
}

@end
