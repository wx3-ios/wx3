//
//  UserBonusEntity.m
//  RKWXT
//
//  Created by SHB on 15/6/27.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "UserBonusEntity.h"

@implementation UserBonusEntity

+(UserBonusEntity*)initUserBonusEntityWithDictionary:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    if(self = [super init]){
        NSInteger begin = [[dic objectForKey:@"begin_time"] integerValue];
        [self setBegin_time:begin];
        
        NSInteger end = [[dic objectForKey:@"end_time"] integerValue];
        [self setEnd_time:end];
        
        NSString *title = [dic objectForKey:@"red_packet_title"];
        [self setTitle:title];
        
        NSString *des = [dic objectForKey:@"red_packet_desc"];
        [self setDesc:des];
        
        NSInteger bonusID = [[dic objectForKey:@"red_packet_id"] integerValue];
        [self setBonusID:bonusID];
        
        NSInteger money = [[dic objectForKey:@"red_packet_size"] integerValue];
        [self setBonusValue:money];
    }
    return self;
}

@end
