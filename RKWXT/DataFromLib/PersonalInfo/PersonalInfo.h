//
//  PersonaInfoEntity.h
//  Woxin2.0
//
//  Created by le ting on 7/30/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

#define D_Notification_Name_PersonalInfoChanged @"D_Notification_Name_PersonalInfoChanged"

@interface PersonalInfo : NSObject
@property (nonatomic,retain)NSString *nickName;
@property (nonatomic,retain)NSString *realName;
@property (nonatomic,retain)NSString *bindNumber;
@property (nonatomic,assign)E_Sex sex;
@property (nonatomic,retain)NSDate *birth;
@property (nonatomic,retain)NSString *qq;
@property (nonatomic,retain)NSString *signature;
@property (nonatomic,retain)NSString *address;
@property (nonatomic,retain)NSString *area;
@property (nonatomic,retain)NSString *iconPath;

+ (PersonalInfo*)sharedPersonal;
- (NSString*)birthString;
@end
