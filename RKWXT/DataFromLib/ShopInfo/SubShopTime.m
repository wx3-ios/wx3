//
//  SubShopTime.m
//  Woxin2.0
//
//  Created by Elty on 12/16/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "SubShopTime.h"

@implementation SubShopTime

- (NSString*)description{
	return [NSString stringWithFormat:@"begin:%d ~ end:%d",(int)_shopTimeBegin,(int)_shopTimeEnd];
}

@end
