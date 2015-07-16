//
//  VersionEntity.m
//  RKWXT
//
//  Created by SHB on 15/3/16.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "VersionEntity.h"

@implementation VersionEntity

+(VersionEntity*)versionWithDictionary:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    if(self = [super init]){
        NSString *appUrl = [dic objectForKey:@"url"];
        [self setAppUrl:appUrl];
        
        NSInteger type = [[dic objectForKey:@"force"] integerValue];
        [self setUpdateType:type];
        
        NSString *message = [dic objectForKey:@"info"];
        [self setUpdateMsg:message];
    }
    return self;
}

@end
