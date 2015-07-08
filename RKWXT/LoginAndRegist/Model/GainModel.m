//
//  GainModel.m
//  RKWXT
//
//  Created by SHB on 15/3/13.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "GainModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation GainModel

-(void)gainNumber:(NSString *)userStr{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userStr, @"phone", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)1], @"type", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_Code httpMethod:WXT_HttpMethod_Post timeoutIntervcal:40 feed:dic completion:^(URLFeedData *retData){
        NSDictionary *dic = retData.data;
        if (retData.code != 0){
            if (_delegate && [_delegate respondsToSelector:@selector(gainNumFailed:)]){
                [_delegate gainNumFailed:retData.errorDesc];
            }
        }else{
            NSInteger smsID = [[dic objectForKey:@"sms_id"] integerValue];
            WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
            [userDefault setSmsID:(int)smsID];
            
            if (_delegate && [_delegate respondsToSelector:@selector(gainNumSucceed)]){
                [_delegate gainNumSucceed];
            }
        }
    }];
}

@end
