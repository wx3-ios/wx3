//
//  FindEntity.m
//  RKWXT
//
//  Created by SHB on 15/3/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "FindEntity.h"

@implementation FindEntity

+(FindEntity*)initFindEntityWith:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *url = [dic objectForKey:@"url"];
        [self setWebUrl:url];
        
        NSString *iconURL = [dic objectForKey:@"icon_url"];
        [self setIcon_url:iconURL];
        
        NSString *name = [dic objectForKey:@"name"];
        [self setName:name];
        
        NSString *type = [dic objectForKey:@"type"];
        [self setType:type];
    }
    return self;
}

+(FindEntity*)initFindTGapWith:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic1:dic];
}

-(id)initWithDic1:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *type = [dic objectForKey:@"type"];
        [self setFind_ygap:[[self class] findTypeWithInteger:type]];
    }
    return self;
}

+(Find_YgapType)findTypeWithInteger:(NSString*)type{
    Find_YgapType ytype = Find_YgapType_None;
    if([type isEqualToString:@"large_space"]){
        ytype = Find_YgapType_BigSpace;
    }
    if([type isEqualToString:@"small_spaces"]){
        ytype = Find_YgapType_SmallSpace;
    }
    
    return ytype;
}

@end
