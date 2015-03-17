//
//  RedPacketEntity.m
//  Woxin2.0
//
//  Created by Elty on 11/25/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "RedPacketEntity.h"

@implementation RedPacketEntity

- (void)dealloc{
	RELEASE_SAFELY(_title);
	RELEASE_SAFELY(_remark);
	RELEASE_SAFELY(_shopName);
	[super dealloc];
}

@end
