//
//  VersionModel.m
//  RKWXT
//
//  Created by SHB on 15/3/16.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "VersionModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "VersionEntity.h"

@interface VersionModel(){
    NSMutableArray *_updateArr;
}
@end

@implementation VersionModel
@synthesize updateArr = _updateArr;

-(id)init{
    self = [super init];
    if(self){
        _updateArr = [[NSMutableArray alloc] init];
    }
    return self;
}

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
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [NSNumber numberWithInt:(int)kMerchantID], @"sid", userDefault.user, @"phone", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_Version httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData){
        NSDictionary *dic = retData.data;
        __block VersionModel *blockSelf = self;
        if (retData.code != 0){
            if (_delegate && [_delegate respondsToSelector:@selector(checkVersionFailed:)]){
                [_delegate checkVersionFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseVersionData:[dic objectForKey:@"data"]];
            if (_delegate && [_delegate respondsToSelector:@selector(checkVersionSucceed)]){
                [_delegate checkVersionSucceed];
            }
        }
    }];
}

@end
