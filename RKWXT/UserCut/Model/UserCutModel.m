//
//  UserCutModel.m
//  RKWXT
//
//  Created by SHB on 15/8/6.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "UserCutModel.h"
#import "UserCutEntity.h"
#import "WXTURLFeedOBJ+NewData.h"

@interface UserCutModel(){
    NSMutableArray *_userCutBalance;
}
@end

@implementation UserCutModel
@synthesize userCutBalance = _userCutBalance;

-(id)init{
    self = [super init];
    if(self){
        _userCutBalance = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)toInit{
    [super toInit];
    [_userCutBalance removeAllObjects];
}

+(UserCutModel*)shareUserCutBalanceModel{
    static dispatch_once_t onceToken;
    static UserCutModel *sharedInstance;
    dispatch_once(&onceToken,^{
        sharedInstance = [[UserCutModel alloc] init];
    });
    return sharedInstance;
}

-(void)parseUserCutDataWidthDic:(NSDictionary*)dic{
    if(!dic){
        return;
    }
    [_userCutBalance removeAllObjects];
    UserCutEntity *entity = [UserCutEntity initUserCutEntityWithDic:dic];
    [_userCutBalance addObject:entity];
}

-(void)loadUserCutBalance{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"", nil];
    __block UserCutModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_Invalid httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_UserCut_LoadFailed object:retData.errorDesc];
        }else{
            [blockSelf parseUserCutDataWidthDic:retData.data];
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_UserCut_LoadSucceed object:nil];
        }
    }];
}

@end
