//
//  CallModel.m
//  RKWXT
//
//  Created by SHB on 15/3/21.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "CallModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+NewData.h"

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
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [NSNumber numberWithInt:(int)kMerchantID], @"sid", userDefault.wxtID, @"woxin_id", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool newStringWithAddSomeStr:5 withOldStr:userDefault.pwd], @"pwd", phoneStr, @"called", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_Call httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        NSDictionary *dic = retData.data;
        if (retData.code != 0){
            _callstatus_type = CallStatus_Type_Ending;
            if (_callDelegate && [_callDelegate respondsToSelector:@selector(makeCallPhoneFailed:)]){
                [_callDelegate makeCallPhoneFailed:retData.errorDesc];
            }
        }else{
            _callstatus_type = CallStatus_Type_Ending;
            if (_callDelegate && [_callDelegate respondsToSelector:@selector(makeCallPhoneSucceed)]){
                [_callDelegate makeCallPhoneSucceed];
            }
            _callID = [dic objectForKey:@"data"];
        }
    }];
}

@end
