//
//  SearchUserAliAccountModel.m
//  RKWXT
//
//  Created by SHB on 15/9/28.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "SearchUserAliAccountModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "UserAliEntity.h"

@interface SearchUserAliAccountModel(){
    NSMutableArray *_userAliAcountArr;
}
@end

@implementation SearchUserAliAccountModel
@synthesize userAliAcountArr = _userAliAcountArr;

-(id)init{
    self = [super init];
    if(self){
        _userAliAcountArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseUserAliAcountData:(NSDictionary*)dic{
    if(!dic){
        return;
    }
    UserAliEntity *entity = [[UserAliEntity alloc] init];
    if([[dic objectForKey:@"data"] isKindOfClass:[NSString class]]){
        entity.userali_type = UserAliCount_Type_None;
        [_userAliAcountArr addObject:entity];
    }else{
        entity = [UserAliEntity initUserAliAcountWithDic:[dic objectForKey:@"data"]];
        [_userAliAcountArr addObject:entity];
    }
}

-(void)searchUserAliPayAccount{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", nil];
    __block SearchUserAliAccountModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_LoadUserAliAccount httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(searchUserAliPayAccountFailed:)]){
                [_delegate searchUserAliPayAccountFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseUserAliAcountData:retData.data];
            if([_delegate respondsToSelector:@selector(searchUserAliPayAccountSucceed)]){
                [_delegate searchUserAliPayAccountSucceed];
            }
        }
    }];
}

@end
