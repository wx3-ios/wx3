//
//  LMGoodsEvaluateEntity.m
//  RKWXT
//
//  Created by SHB on 15/12/29.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMGoodsEvaluateEntity.h"

@implementation LMGoodsEvaluateEntity

+(LMGoodsEvaluateEntity*)initLMGoodsEvaluateEntity:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *content = [dic objectForKey:@"content"];
        [self setContent:content];
        
        NSInteger addTime = [[dic objectForKey:@"add_time"] integerValue];
        [self setAddTime:addTime];
        
        NSString *phone = [dic objectForKey:@"phone"];
        [self setUserPhone:phone];
        
        NSString *nickName = [dic objectForKey:@"nickname"];
        [self setNickName:nickName];
        
        NSString *pic = [dic objectForKey:@"pic"];
        [self setUserHeadImg:pic];
    }
    return self;
}

@end
