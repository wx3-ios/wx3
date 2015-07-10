//
//  RedPacketRule.m
//  Woxin2.0
//
//  Created by Elty on 11/25/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "RedPacketRule.h"
#import "ServiceCommon.h"
//#import "NSObject+SBJson.h"

@interface RedPacketRule()
{
	NSMutableArray *_ruleList;
}
@end

@implementation RedPacketRule
@synthesize ruleList = _ruleList;

- (void)dealloc{
	[self removeOBS];
//	[super dealloc];
}

- (id)init{
	if (self = [super init]){
		_ruleList = [[NSMutableArray alloc] init];
		[self addOBS];
	}
	return self;
}

+ (RedPacketRule*)sharedRedPacketRule{
	static dispatch_once_t onceToken;
	static RedPacketRule *sharedInstance = nil;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[RedPacketRule alloc] init];
	});
	return sharedInstance;
}

- (BOOL)supportRedPacket{
	return [_ruleList count] > 0;
}

- (void)toInit{
	[super toInit];
	[_ruleList removeAllObjects];
}

//- (RpRuleEntity*)nextRpRuleFor:(CGFloat)sum{
//	for (RpRuleEntity *entity in _ruleList){
//		if (entity.over > sum){
//			return entity;
//		}
//	}
//	return [_ruleList lastObject];
//}

//- (RpRuleEntity*)suitRPRuleFor:(CGFloat)sum{
//	NSInteger count = [_ruleList count];
//	for (int i = 0; i < count; i++){
//		RpRuleEntity *entity = [_ruleList objectAtIndex:i];
//		if (entity.over > sum){
//			if (i >= 1){
//				NSInteger index = i-1;
//				return [_ruleList objectAtIndex:index];
//			}else{
//				return nil;
//			}
//		}
//	}
//	return [_ruleList lastObject];
//}

- (E_LoadDataReturnValue)loadRedPacketRule{
	return 0;
}

- (void)addOBS{
}

- (void)removeOBS{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

//- (void)loadedSucceed:(NSNotification*)notification{
//	NSString *obj = notification.object;
//	NSDictionary *dic = [obj JSONValue];
//	NSArray *array = [dic objectForKey:@"data"];
//	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//	NSMutableArray *aList = [NSMutableArray array];
//	for (NSDictionary *aDic in array){
//		RpRuleEntity *entity = [RpRuleEntity rpRuleEntityWithDic:aDic];
//		if (entity){
//			[aList addObject:entity];
//		}
//	}
//	NSArray *sortArray = [aList sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id obj1, id obj2) {
//		RpRuleEntity *entity_0 = obj1;
//		RpRuleEntity *entity_1 = obj2;
//		
//		if (entity_0.over > entity_1.over){
//			return NSOrderedDescending;
//		}else if (entity_0.over < entity_1.over){
//			return NSOrderedAscending;
//		}
//		return NSOrderedSame;
//	}];
//	[_ruleList removeAllObjects];
//	[_ruleList addObjectsFromArray:sortArray];
//	[pool drain];
//	[self setStatus:E_ModelDataStatus_LoadSucceed];
//	[[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_RedPacketRuleLoadedSucceed object:nil];
//}

- (void)loadFailed:(NSNotification*)notification{
	[self setStatus:E_ModelDataStatus_LoadFailed];
	[[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_RedPacketRuleLoadedFailed object:nil];
}

@end
