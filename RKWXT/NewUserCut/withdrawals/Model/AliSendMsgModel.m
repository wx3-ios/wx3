//
//  AliSendMsgModel.m
//  RKWXT
//
//  Created by SHB on 15/9/29.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "AliSendMsgModel.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation AliSendMsgModel

-(void)sendALiMsg:(NSString*)phone{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", phone, @"phone", [NSNumber numberWithInt:(int)4], @"type", [NSNumber numberWithInt:(int)kMerchantID], @"sid", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_Code httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(sendALiMsgFailed:)]){
                [_delegate sendALiMsgFailed:retData.errorDesc];
            }
        }else{
            [userObj setSmsID:[[retData.data objectForKey:@"data"] integerValue]];
            if([_delegate respondsToSelector:@selector(sendALiMsgSucceed)]){
                [_delegate sendALiMsgSucceed];
            }
        }
    }];
}

@end
