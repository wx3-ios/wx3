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
        NSString *appUrl = [dic objectForKey:@"apkUrl"];
        [self setAppUrl:appUrl];
        
        NSInteger type = [[dic objectForKey:@"must_install"] integerValue];
        [self setUpdateType:type];
        
        NSString *version = [dic objectForKey:@"server_version"];
        [self setServiceVersion:version];
        
        NSString *message = [dic objectForKey:@"updateMsg"];
        [self setUpdateMsg:message];
    }
    return self;
}

@end
