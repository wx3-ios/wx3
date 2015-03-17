//
//  SubShopModel.m
//  Woxin2.0
//
//  Created by Elty on 10/16/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "SubShopModel.h"
#import "it_lib.h"
#import "ServiceCommon.h"
#import "NSObject+SBJson.h"

enum{
	E_SUBSHOP_SECTION_
};

@interface SubShopModel()
{
	NSMutableArray *_subShopAreaList;
	
	BOOL _inLoading;//正在加载~
}
@end

@implementation SubShopModel
@synthesize subShopAreaList = _subShopAreaList;

- (void)dealloc{
	RELEASE_SAFELY(_subShopAreaList);
	[self removeOBS];
	[super dealloc];
}

- (id)init{
	if (self = [super init]){
		_subShopAreaList = [[NSMutableArray alloc] init];
		[self addOBS];
	}
	return self;
}

+ (SubShopModel*)sharedSubShopModel{
	static dispatch_once_t onceToken;
	static SubShopModel *model = nil;
	dispatch_once(&onceToken, ^{
		model = [[SubShopModel alloc] init];
	});
	return model;
}

- (SubShopArea*)subShopAreaChose{
	for (SubShopArea *area in _subShopAreaList){
		if (area.isSelected){
			return area;
		}
	}
	return nil;
}

- (void)chooseSubShopArea:(SubShopArea*)area{
	if (!area){
		return;
	}
	
	for (SubShopArea *tempArea in _subShopAreaList){
		[tempArea setIsSelected:NO];
	}
	[area setIsSelected:YES];
}

- (NSInteger)areaIDOfSubShopID:(NSInteger)subShopID{
	for (SubShopArea *area in _subShopAreaList){
		for (SubShop *shop in area.subShopList){
			if (shop.subShopID == subShopID){
				return area.areaID;
			}
		}
	}
	KFLog_Normal(YES, @"没有找到相应的区域ID");
	return -1;
}

- (BOOL)loadSubShopList{
	if (_inLoading){
		KFLog_Normal(YES, @"分店列表正在加载，不需要重复记载");
		return YES;
	}
	_inLoading = YES;
	SS_SHORT ret = IT_MallGetAreaShopInfoIND();
	return ret == 0;
}

- (BOOL)isSubShopListReady{
	return [_subShopAreaList count] > 0;
}

- (void)addOBS{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver:self selector:@selector(loadSubShopListSucceed:) name:D_Notification_Name_Lib_LoadSubShopListSucceed object:nil];
	[notificationCenter addObserver:self selector:@selector(loadSubShopListFailed:) name:D_Notification_Name_Lib_LoadSubShopListFailed object:nil];
}

- (void)loadSubShopListSucceed:(NSNotification*)notification{
	_inLoading = NO;
	if ([self isSubShopListReady]){
		KFLog_Normal(YES, @"分店早已经加载完成了~ ");
		return;
	}
	NSString *jsonString = notification.object;
	NSArray *jsonValue = [jsonString JSONValue];
	
	for (NSDictionary *dic in jsonValue){
		SubShopArea *area = [SubShopArea subShopAreaWithDictionary:dic];
		if (area){
			[_subShopAreaList addObject:area];
		}
	}
	
	//区域ID没有设置的情况下~
	NSInteger defaultAreaID = [WXUserOBJ sharedUserOBJ].areaID;
	if ([_subShopAreaList count] > 0 && defaultAreaID <= 0){
		SubShopArea *area = [_subShopAreaList objectAtIndex:0];
		[area setIsSelected:YES];
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_Model_LoadSubShopListSucceed object:nil];
}

- (void)loadSubShopListFailed:(NSNotification*)notification{
	_inLoading = NO;
	[[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_Model_LoadSubShopListFailed object:nil];
}

- (void)removeOBS{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter removeObserver:self];
}

@end