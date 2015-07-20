//
//  PersonalInfoModel.m
//  RKWXT
//
//  Created by SHB on 15/7/20.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "PersonalInfoModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "PersonalInfoEntity.h"

@interface PersonalInfoModel(){
    NSMutableArray *_personalInfoArr;
}
@end

@implementation PersonalInfoModel
@synthesize personalInfoArr = _personalInfoArr;

-(id)init{
    self = [super init];
    if(self){
        _personalInfoArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)updataUserInfoWith:(NSInteger)sex withNickName:(NSString *)nickName withBirthday:(NSString *)birStr{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"iOS", @"pid",
                         userObj.wxtID, @"woxin_id",
                         userObj.user, @"phone",
                         [NSNumber numberWithInt:_type], @"type",
                         [UtilTool currentVersion], @"ver",
                         [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts",
                         [NSNumber numberWithInteger:sex], @"sex",
                         birStr, @"birthday",
                         nickName, @"nickname",
                         nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_PersonalInfo httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            if(!retData.errorDesc){
                [UtilTool showAlertView:@"上传个人信息失败"];
            }else{
                [UtilTool showAlertView:retData.errorDesc];
            }
        }else{
        }
    }];
}


#pragma mark loadPersonalInfo
-(void)parsePersonalInfo:(NSDictionary*)dic{
    if(!dic){
        return;
    }
    [_personalInfoArr removeAllObjects];
    PersonalInfoEntity *entity = [PersonalInfoEntity initWithPersonalInfoWith:dic];
    [_personalInfoArr addObject:entity];
}

-(void)loadUserInfo{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"iOS", @"pid",
                         userObj.wxtID, @"woxin_id",
                         userObj.user, @"phone",
                         [NSNumber numberWithInt:_type], @"type",
                         [UtilTool currentVersion], @"ver",
                         [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts",
                         nil];
    __block PersonalInfoModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_PersonalInfo httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadPersonalInfoFainled:)]){
                [_delegate loadPersonalInfoFainled:retData.errorDesc];
            }
        }else{
            [blockSelf parsePersonalInfo:[retData.data objectForKey:@"data"]];
            if(_delegate && [_delegate respondsToSelector:@selector(loadPersonalInfoSucceed)]){
                [_delegate loadPersonalInfoSucceed];
            }
        }
    }];
}

@end
