//
//  AreaEntity.m
//  RKWXT
//
//  Created by SHB on 15/11/5.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "AreaEntity.h"

@implementation AreaEntity

+(AreaEntity*)initAreaEntityWith:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    if(self = [super init]){
        NSString *address = [dic objectForKey:@"address"];
        [self setAddress:address];
        
        NSInteger addressID = [[dic objectForKey:@"address_id"] integerValue];
        [self setAddress_id:addressID];
        
        NSString *consignee = [dic objectForKey:@"consignee"];
        [self setUserName:consignee];
        
        NSString *dis = [dic objectForKey:@"county"];
        [self setDisName:dis];
        
        NSString *city = [dic objectForKey:@"municipality"];
        [self setCityName:city];
        
        NSString *province = [dic objectForKey:@"provincial"];
        [self setProName:province];
        
        NSInteger isDefault = [[dic objectForKey:@"is_default"] integerValue];
        [self setNormalID:isDefault];
        
        NSInteger provinceID = [[dic objectForKey:@"provincial_id"] integerValue];
        [self setProID:provinceID];
        
        NSString *userPhone = [dic objectForKey:@"telephone"];
        [self setUserPhone:userPhone];
        
        NSInteger disID = [[dic objectForKey:@"county_id"] integerValue];
        [self setDisID:disID];
        
        NSInteger cityID = [[dic objectForKey:@"municipality_id"] integerValue];
        [self setCityID:cityID];
    }
    return self;
}

@end
