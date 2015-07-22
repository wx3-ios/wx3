//
//  HomeNavENtity.h
//  RKWXT
//
//  Created by SHB on 15/6/17.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeNavENtity : NSObject
@property (nonatomic,strong) NSString *imgUrl;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) NSInteger navID;

+(HomeNavENtity*)homeNavigationEntityWithDic:(NSDictionary*)dic;

@end