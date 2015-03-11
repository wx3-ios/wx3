//
//  HttpNetUtils.h
//  RKWXT
//
//  Created by Elty on 15/3/7.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^CallBack) (id obj);
#define kAgentId            @"2"
#define kTestToken          @"f9e81f23231138fc8e26099471de5e37"
@interface HttpNetUtils : NSObject

+(void)test;
/**
 cmd	login
 phone_number	13888888888
 password	888888
 agent_id	商家ID
 */
+(void)loginHttpActionWith:(NSString *)userName andPasswd:(NSString *)passwd andCallback:(CallBack)callBack;
/**
 cmd	register
 phone_number	13888888888
 agent_id	商家ID
 */
+(void)registerHttpActionWith:(NSString*)phoneNo andCallback:(CallBack)callBack;
/**
 cmd	forget_ password
 phone_number	13888888888
 agent_id	商家ID
 */
+(void)forgetPasswdWith:(NSString *)phoneNo andCallback:(CallBack)callBack;
/**
 cmd	call
 user_id	123234  （13888888888）
 called	13666666666
 agent_id	商家ID
 token	令牌
 */
+(void)callPhoneActionWith:(NSString *)userId andCalled:(NSString *)called andCallback:(CallBack)callBack;
/**
 cmd	pay
 agent_id	商家ID
 user_id	推荐人我信ID （后期考虑：APP端传参数后台暂不处理）
 phone_number	13888888888
 card_sn	88888888
 card_ps	888888
 */
+(void)officialPayWith:(NSString *)userId andPhoneNo:(NSString*)phoneNo andCardSN:(NSString*)cardSN andCardPS:(NSString*)cardPS andCallback:(CallBack)callBack;
/**
 cmd	get_balance
 user_id	123234（13888888888）
 agent_id	商家ID
 token	令牌
 */
+(void)getBalanceWith:(NSString *)userId andCallback:(CallBack)callBack;
/**
 cmd	daily_attendance
 user_id	123234  （13888888888）
 token	令牌
 agent_id	商家ID
 */
+(void)dailyAttendanceWith:(NSString *)userId andCallback:(CallBack)callBack;
@end
