//
//  SubShopAreaOBJ.h
//  Woxin2.0
//
//  Created by Elty on 10/16/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubShop.h"

@interface SubShopArea : NSObject
@property (nonatomic,assign)NSInteger areaID;//区域ID
@property (nonatomic,retain)NSString *areaName;//区域描述
@property (nonatomic,retain)NSArray *subShopList;//该区域的所有分店~
@property (nonatomic,assign)BOOL isSelected;

+ (SubShopArea*)subShopAreaWithDictionary:(NSDictionary*)dic;

@end
