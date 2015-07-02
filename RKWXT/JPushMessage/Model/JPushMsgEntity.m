//
//  JPushMsgEntity.m
//  RKWXT
//
//  Created by SHB on 15/7/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "JPushMsgEntity.h"

@implementation JPushMsgEntity

+(JPushMsgEntity*)initWithJPushMessageWithDic:(NSDictionary *)dic{
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
        
        NSString *ads = [dic objectForKey:@"abstract"];
        [self setAbstract:ads];
        
        NSString *urlImg = [dic objectForKey:@"message_home_img"];
        [self setMsgURL:urlImg];
        
        NSInteger pushID = [[dic objectForKey:@"push_id"] integerValue];
        [self setPush_id:pushID];
    }
    return self;
}

@end
