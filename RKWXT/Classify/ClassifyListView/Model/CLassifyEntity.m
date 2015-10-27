//
//  CLassifyEntity.m
//  RKWXT
//
//  Created by SHB on 15/10/23.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "CLassifyEntity.h"

@implementation CLassifyEntity

+(CLassifyEntity*)initClassifyEntityWith:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *catName = [dic objectForKey:@"cat_name"];
        [self setCatName:catName];
        
        NSInteger catID = [[dic objectForKey:@"cat_id"] integerValue];
        [self setCatID:catID];
        
        NSInteger flag = [[dic objectForKey:@"flag"] integerValue];
        [self setCatType:flag];
        
        
        if(flag == Classify_CatType_None){
            [self setDataArr:nil];
        }
        
        id subData = [dic objectForKey:@"subdata"];
        if([subData isKindOfClass:[NSArray class]]){
            [self setDataArr:subData];
        }
    }
    return self;
}

@end
