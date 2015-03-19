//
//  ShopDescribtion.m
//  Woxin2.0
//
//  Created by Elty on 12/16/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "ShopDesc.h"

@implementation ShopDesc

- (void)dealloc{
//	[super dealloc];
}

+ (ShopDesc*)shopDescribtionWithDictionary:(NSDictionary*)dictionary{
	if (!dictionary){
		return nil;
	}
	return [[self alloc] initWithDictionary:dictionary];
}

- (id)initWithDictionary:(NSDictionary*)dictionary{
	if (self = [super init]){
		[self setDesc:[dictionary objectForKey:@"desc"]];
		[self setUID:[[dictionary objectForKey:@"id"] integerValue]];
		[self setImageURL:[dictionary objectForKey:@"img"]];
	}
	return self;
}

@end
