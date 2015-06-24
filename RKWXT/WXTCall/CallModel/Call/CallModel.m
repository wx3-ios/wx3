//
//  CallModel.m
//  RKWXT
//
//  Created by SHB on 15/3/21.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "CallModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+Data.h"

@implementation CallModel

-(id)init{
    self = [super init];
    if(self){
        _callstatus_type = CallStatus_Type_Normal;
    }
    return self;
}

-(void)changeCallStatus{
    _callstatus_type = CallStatus_Type_Ending;
}

-(void)makeCallPhone:(NSString *)phoneStr{
    if(_callstatus_type == CallStatus_Type_starting){
        return;
    }
    _callstatus_type = CallStatus_Type_starting;
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"call", @"cmd", userDefault.wxtID, @"user_id", [NSNumber numberWithInt:(int)kMerchantID], @"agent_id", phoneStr, @"called", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchDataFromFeedType:WXT_UrlFeed_Type_Call httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        NSDictionary *dic = retData.data;
        if ([[dic objectForKey:@"error"] integerValue] != 1){
            _callstatus_type = CallStatus_Type_Ending;
            if (_callDelegate && [_callDelegate respondsToSelector:@selector(makeCallPhoneFailed:)]){
                [_callDelegate makeCallPhoneFailed:retData.errorDesc];
            }
        }else{
            _callstatus_type = CallStatus_Type_Ending;
            if (_callDelegate && [_callDelegate respondsToSelector:@selector(makeCallPhoneSucceed)]){
                [_callDelegate makeCallPhoneSucceed];
            }
            _callID = [dic objectForKey:@"call_id"];
        }
    }];
}

@end
