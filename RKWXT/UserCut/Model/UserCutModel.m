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
    _cutMoney = 0;
    [_userCutBalance removeAllObjects];
    for(NSDictionary *dataDic in [dic objectForKey:@"data"]){
        UserCutEntity *entity = [UserCutEntity initUserCutEntityWithDic:dataDic];
        _cutMoney += entity.money;
        [_userCutBalance addObject:entity];
    }
    [self changeTurnForAllUserCutArr:_userCutBalance];
}

-(void)changeTurnForAllUserCutArr:(NSMutableArray*)arr{
    [arr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        UserCutEntity *item1 = obj1;
        UserCutEntity *item2 = obj2;
        if (item1.date < item2.date){
            return NSOrderedDescending;
        }else if (item1.date == item2.date){
            return NSOrderedSame;
        }else{
            return NSOrderedAscending;
        }
    }];
}

-(void)loadUserCutBalance{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.sellerID, @"seller_user_id", @"iOS", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", userObj.wxtID, @"woxin_id", [NSNumber numberWithInteger:kMerchantID], @"sid", [NSNumber numberWithInteger:kSubShopID], @"shop_id", nil];
    __block UserCutModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_UserCut httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_UserCut_LoadFailed object:retData.errorDesc];
        }else{
            [blockSelf parseUserCutDataWidthDic:retData.data];
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_UserCut_LoadSucceed object:nil];
        }
    }];
}

@end
