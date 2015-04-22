//
//  HangupModel.m
//  RKWXT
//
//  Created by SHB on 15/4/21.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "HangupModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+Data.h"

@implementation HangupModel

-(id)init{
    self = [super init];
    if(self){
    }
    return self;
}

-(void)hangupWithCallID:(NSString *)callID{
    if(!callID){
        return;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"hangup", @"cmd", callID, @"call_id", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchDataFromFeedType:WXT_UrlFeed_Type_FetchPwd httpMethod:WXT_HttpMethod_Get timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData){
        NSDictionary *dic = retData.data;
        if ([[dic objectForKey:@"success"] integerValue] != 1){
            if (_hangupDelegate && [_hangupDelegate respondsToSelector:@selector(hangupFailed:)]){
                [_hangupDelegate hangupFailed:retData.errorDesc];
            }
        }else{
            if (_hangupDelegate && [_hangupDelegate respondsToSelector:@selector(hangupSucceed)]){
                [_hangupDelegate hangupSucceed];
            }
        }
    }];
}

@end

