//
//  TopADVEntity.m
//  Woxin2.0
//
//  Created by Elty on 11/24/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "TopADVEntity.h"

@implementation TopADVEntity

- (void)dealloc{
//	[super dealloc];
}

+ (TopADVEntity*)topADVEntityWithDictionary:(NSDictionary*)dic{
	if (!dic){
		return nil;
	}
	return [[self alloc] initWithDictionary:dic] ;
}

- (id)initWithDictionary:(NSDictionary*)dic{
	if (self = [super init]){
		E_TopADVType msgType = [[dic objectForKey:@"type_id"] integerValue];
		[self setAdvType:msgType];
		NSInteger msgID = [[dic objectForKey:@"id"] integerValue];
		[self setMsgID:msgID];
		NSString *msgURL = [dic objectForKey:@"id_url"];
		[self setMsgURL:msgURL];
		NSInteger sortID = [[dic objectForKey:@"sort"] integerValue];
		[self setSortID:sortID];
		NSString *imageURL = [dic objectForKey:@"url"];
		[self setImageURL:imageURL];
		[self setTitle:@"我信"];
	}
	return self;
}

- (NSString*)description{
	return [NSString stringWithFormat:@"advType = %d msgID = %d msgURL = %@ sortID = %d imageURL = %@",_advType,_msgID,_msgURL,_sortID,_imageURL];
}

@end
