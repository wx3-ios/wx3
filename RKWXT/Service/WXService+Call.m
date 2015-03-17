//
//  WXService+Call.m
//  Woxin2.0
//
//  Created by le ting on 7/24/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXService.h"
@implementation WXService (Call)

- (BOOL)makeBackCall:(NSString*)phone{
    const char *pCaller = [[WXUserOBJ sharedUserOBJ].user cStringUsingEncoding:NSUTF8StringEncoding];
    const char *pCalled = [phone cStringUsingEncoding:NSUTF8StringEncoding];
	NSInteger callID = [[WXUserDefault sharedWXUserDefault] integerValueForKey:D_WXUserdefault_Key_iBackCallID];
	callID +=1;
	callID = callID%1000;
	[[WXUserDefault sharedWXUserDefault] setInteger:callID forKey:D_WXUserdefault_Key_iBackCallID];
    SS_SHORT ret = IT_CallBackIND(pCaller, pCalled, callID, kAPPType,0);
    if(ret != 0){
        KFLog_Normal(YES, @"make back call failed:%d",(int)ret);
    }
    return ret == 0;
}

- (BOOL)hangUpBackCall:(NSString*)phone{
    const char *pCaller = [[WXUserOBJ sharedUserOBJ].user cStringUsingEncoding:NSUTF8StringEncoding];
    const char *pCalled = [phone cStringUsingEncoding:NSUTF8StringEncoding];
    SS_SHORT ret = IT_CallBackHookIND(pCaller, pCalled);
    if(ret!= 0){
        KFLog_Normal(YES, @"挂断回拨失败 = %d",(int)ret);
    }
    return ret == 0;
}

- (BOOL)makeCall:(NSString*)phone{
    const char *pCaller = [[WXUserOBJ sharedUserOBJ].user cStringUsingEncoding:NSUTF8StringEncoding];
    const char *pCalled = [phone cStringUsingEncoding:NSUTF8StringEncoding];
    SS_SHORT ret = IT_MakeCall(pCaller, pCaller, pCaller, pCalled, pCalled);
    if(ret != 0){
        KFLog_Normal(YES, @"make call failed:%d",(int)ret);
    }
    return ret == 0;
}
- (BOOL)cancelCall{
    SS_SHORT ret = IT_CancelCall();
    if(ret != 0){
        KFLog_Normal(YES, @"cancelCall Failed:%d",(int)ret);
    }
    return ret == 0;
}
- (BOOL)alertCall{
    SS_SHORT ret = IT_AlertingCall();
    if(ret != 0){
        KFLog_Normal(YES, @"alertCall failed:%d",(int)ret);
    }
    return ret == 0;
}
- (BOOL)answerCall{
    SS_SHORT ret = IT_AnswerCall();
    if(ret != 0){
        KFLog_Normal(YES, @"answer call Failed:%d",(int)ret);
    }
    return ret == 0;
}
- (BOOL)rejectCall:(BOOL)isOverTime{
    SS_SHORT ret = 0;
    if(isOverTime){
        ret = IT_RejectCall(2);
    }else{
        ret = IT_RejectCall(1);
    }
    if(ret != 0){
        KFLog_Normal(YES, @"reject call Failed:%d",(int)ret);
    }
    return ret == 0;
}
- (BOOL)releaseCall{
    SS_SHORT ret = IT_ReleaseCall();
    if(ret != 0){
        KFLog_Normal(YES, @"release call Failed:%d",(int)ret);
    }
    return ret == 0;
}

- (BOOL)setCallTimeOut:(NSUInteger)timeOut{
    return IT_SetCallTimeOut((SS_SHORT)timeOut) == 0;
}

- (BOOL)setPCMCallBack:(PCMCallBack)pcmCallBack{
    NSInteger ret = IT_SetPCMCallBack(pcmCallBack);
    if(ret != 0){
        KFLog_Normal(YES, @"set pcm callback failed");
    }
    return ret == 0;
}

- (BOOL)sendPCM:(NSData*)pcmData{
    NSUInteger length = [pcmData length];
    if(pcmData && length > 0){
        const void *pcmBuffer = [pcmData bytes];
        SS_SHORT ret = IT_SendPCM(pcmBuffer, (SS_SHORT)length);
        if(ret != 0){
            KFLog_Normal(YES, @"send pcm data failed: %d",ret);
        }
        return ret == 0;
    }
    return YES;
}
@end
