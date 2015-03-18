//
//  ZoneCodeOBJ.m
//  Woxin2.0
//
//  Created by Elty on 11/13/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "ZoneCodeOBJ.h"
#import "ZoneCodeEntity.h"
#import "TxtparseOBJ.h"

#define kMaxPhoneLen 8
#define kMinPhoneLen 7
@interface ZoneCodeOBJ()
{
	__unsafe_unretained NSMutableArray *_zoneCodeList;
}
@end

@implementation ZoneCodeOBJ
@synthesize zoneCodeList = _zoneCodeList;

- (void)dealloc{
//	[super dealloc];
}

- (id)init{
	if (self = [super init]){
		_zoneCodeList = [[NSMutableArray alloc] init];
		[self loadZoneCodeList];
	}
	return self;
}

- (void)loadZoneCodeList{
	[_zoneCodeList removeAllObjects];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"ZoneCode" ofType:nil];
	NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
	NSArray *zoneCodeDatas = [TxtparseOBJ parseDataFrom:string itemSeparator:@"\n" elementSeparator:@"\t"];
	
//	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	for(NSArray *zoneCodeItemArray in zoneCodeDatas){
		ZoneCodeEntity *entity = [ZoneCodeEntity zoneCodeEntityWithArray:zoneCodeItemArray];
		if (entity){
			[_zoneCodeList addObject:entity];
		}
	}
//	[pool drain];
}

+ (ZoneCodeOBJ*)sharedZoneCodeOBJ{
	static dispatch_once_t onceToken;
	static ZoneCodeOBJ *sharedInstance = nil;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[ZoneCodeOBJ alloc] init];
	});
	return sharedInstance;
}

- (WXError*)checkPhone:(NSString*)phone validFor:(ZoneCodeEntity*)zoneCode{
	NSString *prefix = zoneCode.zoneCode;
	WXError *error = [[WXError alloc] init] ;
	if ([phone hasPrefix:prefix]){
		NSInteger phoneLen = [phone length];
		NSInteger zoneCodeLen = prefix.length;
		if (phoneLen > zoneCodeLen+ kMaxPhoneLen || phoneLen < zoneCodeLen+kMinPhoneLen){
			error.errorCode = E_ZoneCodeMathCode_Part;
//			error.errorMessage = [NSString stringWithFormat:@"%@的座机号码有%d位",zoneCode.zoneName,(int)zoneCode.phoneLen];
			error.errorMessage = @"请输入正确的号码";
		}else{
			error.errorCode = E_ZoneCodeMathCode_Complete;
		}
	}else{
		error.errorCode = E_ZoneCodeMathCode_None;
	}
	return error;
}

- (WXError*)checkValidForPhone:(NSString*)phone{
	WXError *error = nil;
	for (ZoneCodeEntity *entity in _zoneCodeList){
		error = [self checkPhone:phone validFor:entity];
		if (error.errorCode != E_ZoneCodeMathCode_None){
			break;
		}
	}
	return error;
}

@end
