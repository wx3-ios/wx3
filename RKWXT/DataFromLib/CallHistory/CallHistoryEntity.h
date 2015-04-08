//
//  CallHistoryEntity.h
//  Woxin2.0
//
//  Created by le ting on 7/29/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    E_CallHistoryType_IncommingUnread = 2,//未接来电
    E_CallHistoryType_MakingUnread = 5,//未接去电
    E_CallHistoryType_IncommingReaded = 1,//已接来电
    E_CallHistoryType_MakingReaded = 4,//已接去电
    
    E_CallHistoryType_MakingReaded_Invalid = -1,
}E_CallHistoryType;

enum{
    E_CallRecordParamIndex_UID = 0,
    E_CallRecordParamIndex_Phone,
    E_CallRecordParamIndex_Start,
    E_CallRecordParamIndex_Duration,
    E_CallRecordParamIndex_Type,
    
    E_CallRecordParamIndex_Invalid,
};

@interface CallHistoryEntity : NSObject
@property (nonatomic,assign)NSInteger UID;
@property (nonatomic, retain)NSString * name;
@property (nonatomic,retain)NSString *phoneNumber; //电话号码
@property (nonatomic,retain)NSString *wxID;//我信ID
@property (nonatomic,assign)E_CallHistoryType historyType;//历史记录的类型
@property (nonatomic,retain)NSDate *startTime;//开始时间
@property (nonatomic,retain)NSString *callStartTime;//开始时间
@property (nonatomic, retain)NSString * date;
@property (nonatomic,assign)NSInteger duration;//通话时长
@property (nonatomic,assign)E_CallHistoryType callType;//通话类型

+ (CallHistoryEntity*)recordWithParamArray:(NSArray*)paramArray;
- (BOOL)canMergeRecord:(CallHistoryEntity*)entity;

-(CallHistoryEntity*)initWithName:(NSString*)name telephone:(NSString*)telephone date:(NSString*)date type:(E_CallHistoryType)type;
-(CallHistoryEntity*)initWithName:(NSString*)name telephone:(NSString*)telephone startTime:(NSString*)aStartTime duration:(NSInteger)aDuration type:(E_CallHistoryType)type;
@end
