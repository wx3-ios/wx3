//
//  PersonaInfoEntity.m
//  Woxin2.0
//
//  Created by le ting on 7/30/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#define D_BirthSepator @"-"

#import "PersonalInfo.h"
#import "ServiceCommon.h"

@implementation PersonalInfo

- (void)dealloc{
    [self removeOBS];
//    [super dealloc];
}

+ (PersonalInfo*)sharedPersonal{
    static dispatch_once_t onceToken;
    static PersonalInfo *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PersonalInfo alloc] init];
    });
    return sharedInstance;
}

- (id)init{
    if(self = [super init]){
        [self addOBS];
    }
    return self;
}

- (NSString*)birthString{
    NSString *birthStr = @"1970-1-1";
    if(_birth){
        NSDateComponents *dateComponents = [_birth dateComponents];
        birthStr = [NSString stringWithFormat:@"%d%@%d%@%d",(int)dateComponents.year,D_BirthSepator,
                              (int)dateComponents.month,D_BirthSepator,(int)dateComponents.day];
    }
    return birthStr;
}

- (void)setPersonalInfo:(NSArray*)paramArray{
    
}

- (void)addOBS{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personalInfoChanged:) name:D_Notification_Name_Server_PersonalInfoChanged object:nil];
}

- (void)personalInfoChanged:(NSNotification*)notification{
    NSArray *array = notification.object;
    if(array && [array isKindOfClass:[NSArray class]]){
        [self setPersonalInfo:array];
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:D_Notification_Name_PersonalInfoChanged object:nil userInfo:nil];
    }
}

- (void)removeOBS{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
