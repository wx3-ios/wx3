//
//  SubShopAreaOBJ.m
//  Woxin2.0
//
//  Created by Elty on 10/16/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "SubShopArea.h"

@interface SubShopArea()
{
	NSMutableArray *_subShopList;
}
@end

@implementation SubShopArea

- (void)dealloc{
//	[super dealloc];
}

+ (SubShopArea*)subShopAreaWithDictionary:(NSDictionary*)dic{
	return [[[self class] alloc] initWithDic:dic] ;
}

- (id)initWithDic:(NSDictionary*)dic{
	if (self = [super init]){
		_subShopList = [[NSMutableArray alloc] init];
		
		NSInteger ID = [[dic objectForKey:@"id"] integerValue];
		[self setAreaID:ID];
		[self setAreaName:[dic objectForKey:@"name"]];
		
		NSArray *shopList = [dic objectForKey:@"shop"];
		for (NSDictionary *dic in shopList){
			SubShop *shop = [SubShop subShopWithDictionary:dic];
			if (shop){
				[_subShopList addObject:shop];
			}
		}
		if (ID == [WXUserOBJ sharedUserOBJ].areaID){
			[self setIsSelected:YES];
		}
	}
	return self;
}

@end
