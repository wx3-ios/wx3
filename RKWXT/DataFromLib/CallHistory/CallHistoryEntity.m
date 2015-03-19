//
//  CallHistoryEntity.m
//  Woxin2.0
//
//  Created by le ting on 7/29/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "CallHistoryEntity.h"
#import "TelNOOBJ.h"

enum{
    E_CallRecordPramIndex_UID = 0,
    E_CallRecordPramIndex_Phone,
    E_CallRecordPramIndex_Type,
    E_CallRecordPramIndex_Start,
    E_CallRecordPramIndex_Duration,
    
    E_CallRecordPramIndex_Invalid,
};

@implementation CallHistoryEntity

- (void)dealloc{
//    [super dealloc];
}

+ (CallHistoryEntity*)recordWithPramArray:(NSArray*)pramArray{
    return [[CallHistoryEntity alloc] initWithParamArray:pramArray] ;
}

- (id)initWithParamArray:(NSArray*)pramArray{
    if([pramArray count] != E_CallRecordPramIndex_Invalid){
        return nil;
    }
    if(self = [super init]){
        NSInteger UID = [[pramArray objectAtIndex:E_CallRecordPramIndex_UID] integerValue];
        [self setUID:UID];
        
        NSString *phoneNumber = pramArray[E_CallRecordPramIndex_Phone];
        phoneNumber = [[TelNOOBJ sharedTelNOOBJ] telNumberFromOrigin:phoneNumber];
        [self setPhoneNumber:phoneNumber];
        E_CallHistoryType type = [self callRecordTypeOf:[pramArray objectAtIndex:E_CallRecordPramIndex_Type]];
        [self setHistoryType:type];
        NSInteger startTime = [[pramArray objectAtIndex:E_CallRecordPramIndex_Start] integerValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:startTime];
        [self setStartTime:date];
        NSInteger duration = [[pramArray objectAtIndex:E_CallRecordPramIndex_Duration] integerValue];
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

@end
