//
//  MallEntity.m
//  RKWXT
//
//  Created by SHB on 15/3/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "MallEntity.h"

@implementation MallEntity

+(MallEntity*)initMallDataWithDic:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSInteger display = [[dic objectForKey:@"display_mall"] integerValue];
        if(display == 1){
            [self setMall_type:Mall_Show];
        }else{
            [self setMall_type:Mall_UnShow];
        }
        
        NSString *mall_home_url = [dic objectForKey:@"mall_home_url"];
        [self setMall_url:mall_home_url];
        
        NSString *mall_update_flag = [dic objectForKey:@"mall_update_flag"];
        [self setMall_update:mall_update_flag];
    }
    return self;
}


@end
