//
//  VersionModel.m
//  RKWXT
//
//  Created by SHB on 15/3/16.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "VersionModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+Data.h"
#import "VersionEntity.h"

@interface VersionModel(){
    NSMutableArray *_updateArr;
}
@end

@implementation VersionModel
@synthesize updateArr = _updateArr;

-(void)parseVersionData:(NSDictionary*)dic{
    if(!dic){
        return;
    }
    VersionEntity *entity = [VersionEntity versionWithDictionary:dic];
    [_updateArr addObject:entity];
}

-(void)checkVersion:(NSString*)currentVersion{
    [_updateArr removeAllObjects];
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"check_ios_update", @"cmd", userDefault.wxtID, @"user_id", [NSNumber numberWithInt:ShopID], @"agent_id", userDefault.token, @"token", currentVersion, @"ver", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchDataFromFeedType:WXT_UrlFeed_Type_Version httpMethod:WXT_HttpMethod_Get timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData){
        NSDictionary *dic = retData.data;
        __block VersionModel *model = nil;
        if ([[dic objectForKey:@"success"] integerValue] != 1){
            if (_delegate && [_delegate respondsToSelector:@selector(checkVersionFailed:)]){
                [_delegate checkVersionFailed:retData.errorDesc];
            }
        }else{
            [model parseVersionData:dic];
            if (_delegate && [_delegate respondsToSelector:@selector(checkVersionSucceed)]){
                [_delegate checkVersionSucceed];
            }
        }
    }];
}

@end
