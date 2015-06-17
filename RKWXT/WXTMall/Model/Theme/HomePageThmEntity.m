//
//  HomePageThmEntity.m
//  RKWXT
//
//  Created by SHB on 15/5/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "HomePageThmEntity.h"

@implementation HomePageThmEntity

+(HomePageThmEntity*)homePageThmEntityWithDictionary:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    if(self = [super init]){
        NSString *name = [dic objectForKey:@"cat_name"];
        [self setCat_name:name];
        
        NSInteger catId = [[dic objectForKey:@"cat_id"] integerValue];
        [self setCat_id:catId];
        
        NSString *desc = [dic objectForKey:@"cat_desc"];
        [self setCat_intro:desc];
        
        NSString *imgUrl = [dic objectForKey:@"cat_img"];
        [self setCategory_img:imgUrl];
    }
    return self;
}

@end
