//
//  CallHistoryEntity.m
//  Woxin2.0
//
//  Created by le ting on 7/29/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "CallHistoryEntity.h"
#import "TelNOOBJ.h"

@implementation CallHistoryEntity


+ (CallHistoryEntity*)recordWithParamArray:(NSArray*)paramArray{
    return [[CallHistoryEntity alloc] initWithParamArray:paramArray] ;
}

- (id)initWithParamArray:(NSArray*)paramArray{
    if([paramArray count] != E_CallRecordParamIndex_Invalid){
        return nil;
    }
    if(self = [super init]){
        NSInteger UID = [[paramArray objectAtIndex:E_CallRecordParamIndex_UID] integerValue];
        [self setUID:UID];
        
        NSString *phoneNumber = paramArray[E_CallRecordParamIndex_Phone];
        phoneNumber = [[TelNOOBJ sharedTelNOOBJ] telNumberFromOrigin:phoneNumber];
        [self setPhoneNumber:phoneNumber];
        NSString *nameStr = [paramArray objectAtIndex:E_CallRecordParamIndex_Name];
        [self setName:nameStr];
        E_CallHistoryType type = [self callRecordTypeOf:[paramArray objectAtIndex:E_CallRecordParamIndex_Type]];
        [self setHistoryType:type];
        //        NSInteger startTime = [[paramArray objectAtIndex:E_CallRecordParamIndex_Start] integerValue];
        NSString * startTime = [paramArray objectAtIndex:E_CallRecordParamIndex_Start];
        //        NSDate *date = [NSDate dateWithTimeIntervalSince1970:startTime];
        [self setCallStartTime:startTime];
        NSInteger duration = [[paramArray objectAtIndex:E_CallRecordParamIndex_Duration] integerValue];
        [self setDuration:duration];
    }
    return self;
}

//1 呼入 2 呼入未接 3 呼入拒接  4 呼出  5 呼出未接 6 呼出拒接 7 回拨  8 回拨主叫拒接 9 回拨被叫忙/被叫拒接
- (E_CallHistoryType)callRecordTypeOf:(NSString*)hisType{
    NSInteger type = [hisType integerValue];
    E_CallHistoryType callRecordType = E_CallHistoryType_MakingReaded_Invalid;
    switch (type) {
        case 1:
            callRecordType = E_CallHistoryType_IncommingReaded;
            break;
        case 4:case 7:
            callRecordType = E_CallHistoryType_MakingReaded;
            break;
        case 3:case 2:
            callRecordType = E_CallHistoryType_IncommingUnread;
            break;
        case 5:case 6:case 8: case 9:
            callRecordType = E_CallHistoryType_MakingUnread;
            break;
        default:
            break;
    }
    return callRecordType;
}

- (BOOL)canMergeRecord:(CallHistoryEntity*)entity{
    NSString *phoneNumber1 = entity.phoneNumber;
    NSString *phoneNumber2 = self.phoneNumber;
    BOOL ret = [phoneNumber1 isEqualToString:phoneNumber2] && (self.historyType == entity.historyType);
    return ret;
}

-(CallHistoryEntity*)initWithName:(NSString*)name telephone:(NSString*)telephone date:(NSString*)date type:(E_CallHistoryType)type{
    CallHistoryEntity * entity = [[CallHistoryEntity alloc] init];
    entity.name = name;
    entity.phoneNumber = telephone;
    entity.date = date;
    return entity;
}

-(CallHistoryEntity*)initWithName:(NSString*)name telephone:(NSString*)telephone startTime:(NSString*)aStartTime duration:(NSInteger)aDuration type:(E_CallHistoryType)type{
    CallHistoryEntity * entity = [[CallHistoryEntity alloc] init];
    entity.name = name;
    entity.phoneNumber = telephone;
    entity.callStartTime = aStartTime;
    entity.duration = aDuration;
    entity.callType = type;
    return entity;
}
@end
