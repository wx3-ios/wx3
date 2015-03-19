//
//  RedPacketRule.h
//  Woxin2.0
//
//  Created by Elty on 11/25/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "BaseModel.h"
//#import "RpRuleEntity.h"

#define D_Notification_RedPacketRuleLoadedSucceed	@"D_Notification_RedPacketRuleLoadedSucceed"
#define D_Notification_RedPacketRuleLoadedFailed @"D_Notification_RedPacketRuleLoadedFailed"

@interface RedPacketRule : BaseModel
@property (nonatomic,readonly)NSArray *ruleList;

+ (RedPacketRule*)sharedRedPacketRule;
- (BOOL)supportRedPacket;
- (E_LoadDataReturnValue)loadRedPacketRule;
//- (RpRuleEntity*)suitRPRuleFor:(CGFloat)sum; //适合总价格为sum的规则
//- (RpRuleEntity*)nextRpRuleFor:(CGFloat)sum;//下一个适合总价格为sum的规则
@end
