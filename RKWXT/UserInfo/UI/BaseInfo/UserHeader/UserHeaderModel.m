//
//  UserHeaderModel.m
//  RKWXT
//
//  Created by SHB on 15/9/9.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "UserHeaderModel.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation UserHeaderModel

+(UserHeaderModel*)shareUserHeaderModel{
    static dispatch_once_t onceToken;
    static UserHeaderModel *sharedInstance = nil;
    dispatch_once(&onceToken,^{
        sharedInstance = [[UserHeaderModel alloc] init];
    });
    return sharedInstance;
}

-(void)loadUserHeaderImageWith{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"iOS", @"pid",
                         [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts",
                         userObj.wxtID, @"woxin_id",
                         userObj.sellerID, @"seller_user_id",
                         nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_LoadUserHeader httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
        }else{
            [self setUserHeaderImg:[NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,[retData.data objectForKey:@"data"]]];
        }
    }];
}

-(void)updateUserHeaderSucceed:(NSString *)headerPath{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"iOS", @"pid",
                         [UtilTool currentVersion], @"ver",
                         [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts",
                         headerPath, @"pic_name",
                         userObj.wxtID, @"woxin_id",
                         userObj.sellerID, @"seller_user_id",
                         [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.pwd], @"pwd",
                         nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_UpdateUserHeader httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
        }else{
        }
    }];
}

@end
