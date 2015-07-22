//
//  HomeNavENtity.m
//  RKWXT
//
//  Created by SHB on 15/6/17.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "HomeNavENtity.h"

@implementation HomeNavENtity

+(HomeNavENtity*)homeNavigationEntityWithDic:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSInteger nav_id = [[dic objectForKey:@"top_nav_type_id"] integerValue];
        [self setType:nav_id];
        
        NSString *title = [dic objectForKey:@"nav_title"];
        [self setName:title];
        
        NSString *content = [dic objectForKey:@"nav_content"];
        [self setDesc:content];
        
        NSString *imgUrl = [dic objectForKey:@"nav_img"];
        [self setImgUrl:imgUrl];
        
        NSInteger address = [[dic objectForKey:@"nav_address_id"] integerValue];
        [self setNavID:address];
    }
    return self;
}

@end
