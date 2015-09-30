//
//  WithdrawalsRecordEntity.m
//  RKWXT
//
//  Created by SHB on 15/9/29.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WithdrawalsRecordEntity.h"

@implementation WithdrawalsRecordEntity

+(WithdrawalsRecordEntity*)initAliRecordListWithDic:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSInteger addTime = [[dic objectForKey:@"add_time"] integerValue];
        [self setAddTime:addTime];

        NSInteger completeTime = [[dic objectForKey:@"complete_time"] integerValue];
        [self setCompleteTime:completeTime];

        CGFloat money = [[dic objectForKey:@"amount"] floatValue];
        [self setMoney:money];

        NSInteger status = [[dic objectForKey:@"is_complete"] integerValue];
        [self setAli_type:status];

        NSString *phone = [dic objectForKey:@"withdraw_account"];
        [self setPhoneStr:phone];
    }
    return self;
}

@end
