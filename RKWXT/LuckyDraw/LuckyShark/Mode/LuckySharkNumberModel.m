//
//  LuckySharkNumberModel.m
//  RKWXT
//
//  Created by SHB on 15/8/24.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckySharkNumberModel.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation LuckySharkNumberModel

-(void)loadLuckySharkNumber{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInteger:[UtilTool timeChange]], @"ts", [NSNumber numberWithInteger:kMerchantID], @"sid", userObj.user, @"phone", userObj.wxtID, @"woxin_id", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_SharkNumber httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadLuckySharkNumberFailed:)]){
                [_delegate loadLuckySharkNumberFailed:retData.errorDesc];
            }
        }else{
            NSInteger chance = [[[retData.data objectForKey:@"data"] objectForKey:@"lottery_chance"] integerValue];
            NSInteger everyDay = [[[retData.data objectForKey:@"data"] objectForKey:@"lottery_chance_day"] integerValue];
            _number = chance+everyDay;
            if(_delegate && [_delegate respondsToSelector:@selector(loadLuckySharkNumberSucceed)]){
                [_delegate loadLuckySharkNumberSucceed];
            }
        }
    }];
}

@end
