//
//  SetMealEntity.h
//  Woxin2.0
//
//  Created by le ting on 8/7/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXGoodEntity.h"

@interface SetMealEntity : NSObject
@property (nonatomic,assign)NSInteger UID; //套餐ID
@property (nonatomic,readonly)NSArray *foodArray; //套餐的菜品
@property (nonatomic,retain)NSString *name;//套餐名称
@property (nonatomic,assign)CGFloat price; //套餐价格~

+ (SetMealEntity*)entityWithDictionary:(NSDictionary*)dic;
- (CGFloat)originPrice;//原价
@end


@interface FootOBJ :NSObject
@property (nonatomic,assign)NSInteger goodID;
@property (nonatomic,assign)NSInteger number;

- (WXGoodEntity*)goodEntity;
@end
