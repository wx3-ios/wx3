//
//  SetMealEntity.m
//  Woxin2.0
//
//  Created by le ting on 8/7/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "SetMealEntity.h"
#import "WXGoodListModel.h"

@interface SetMealEntity()
{
    NSMutableArray *_foodArray;
}
@end
@implementation SetMealEntity
@synthesize foodArray = _foodArray;

- (void)dealloc{
//    [super dealloc];
}

+ (SetMealEntity*)entityWithDictionary:(NSDictionary*)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDictionary:dic] ;
}

- (id)init{
    if(self =[super init]){
        _foodArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dic{
    if(self = [self init]){
        NSInteger mealID = [[dic objectForKey:@"id"] integerValue];
        CGFloat price = [[dic objectForKey:@"price"] floatValue];
        NSString *name = [dic objectForKey:@"name"];
        
        NSArray *goods = [dic objectForKey:@"data"];
        for(NSDictionary *dic in goods){
            FootOBJ *footOBJ = [[FootOBJ alloc] init] ;
            [footOBJ setGoodID:[[dic objectForKey:@"id"] integerValue]];
            [footOBJ setNumber:[[dic objectForKey:@"num"] integerValue]];
            [_foodArray addObject:footOBJ];
        }
        [self setUID:mealID];
        [self setPrice:price];
        [self setName:name];
    }
    return self;
}

- (CGFloat)originPrice{
    CGFloat originPrice = 0.0;
    for(FootOBJ *obj in _foodArray){
        WXGoodEntity *goodEntity = [obj goodEntity];
        if(goodEntity){
            originPrice += goodEntity.shopPrice*obj.number;
        }
    }
    return originPrice;
}

- (NSString*)description{
	return [NSString stringWithFormat:@"ID=%d foodArray=%@ name=%@",(int)_UID,_foodArray,_name];
}

@end

@implementation FootOBJ

- (WXGoodEntity*)goodEntity{
    return [[WXGoodListModel sharedGoodListModel] goodsOfID:_goodID];
}

- (NSString*)description{
	return [NSString stringWithFormat:@"ID =%d number=%d",(int)_goodID,(int)_number];
}

@end

