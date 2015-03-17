//
//  ZoneCodeEntity.m
//  Woxin2.0
//
//  Created by Elty on 11/13/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "ZoneCodeEntity.h"

enum{
	E_ZoneCode_Index_Name = 0,//区域名称
	E_ZoneCode_Index_ID,//区域码
	
	E_ZoneCode_Index_Invalid,
//	E_ZoneCode_Index_Len,//区域码长度
};

@implementation ZoneCodeEntity

- (void)dealloc{
	RELEASE_SAFELY(_zoneName);
	RELEASE_SAFELY(_zoneCode);
	[super dealloc];
}

+ (ZoneCodeEntity*)zoneCodeEntityWithArray:(NSArray*)objArray{
	if([objArray count] != E_ZoneCode_Index_Invalid){
		return nil;
	}
	return [[[self alloc] initWithArray:objArray] autorelease];
}

- (id)initWithArray:(NSArray*)objArray{
	if (self = [super init]){
		NSString *name = [objArray objectAtIndex:E_ZoneCode_Index_Name];
		NSString *zoneID = [objArray objectAtIndex:E_ZoneCode_Index_ID];
		[self setZoneName:name];
		[self setZoneCode:zoneID];
	}
	return self;
}

- (NSString*)description{
	return [NSString stringWithFormat:@"name=%@ zoneID =%@ length=%d",_zoneName,_zoneCode,_phoneLen];
}

@end
