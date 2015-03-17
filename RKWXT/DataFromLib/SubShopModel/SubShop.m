//
//  SubShopOBJ.m
//  Woxin2.0
//
//  Created by Elty on 10/16/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "SubShop.h"

@implementation SubShop

- (void)dealloc{
	RELEASE_SAFELY(_shopName);
	RELEASE_SAFELY(_shopImage);
	[super dealloc];
}

+ (SubShop*)subShopWithDictionary:(NSDictionary*)dic{
	return [[[[self class] alloc] initWithDic:dic] autorelease];
}

- (id)initWithDic:(NSDictionary*)dic{
	if (self = [super init]){
		NSInteger ID = [[dic objectForKey:@"id"] integerValue];
		[self setSubShopID:ID];
		[self setShopName:[dic objectForKey:@"name"]];
		[self setShopImage:[dic objectForKey:@"img"]];
		
		if (ID == [WXUserOBJ sharedUserOBJ].subShopID){
			[self setIsSelected:YES];
		}
	}
	return self;
}

@end
