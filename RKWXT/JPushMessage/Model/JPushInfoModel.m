//
//  JPushInfoModel.m
//  RKWXT
//
//  Created by SHB on 15/7/15.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "JPushInfoModel.h"
#import "WXTURLFeedOBJ+NewData.h"

@interface JPushInfoModel(){
    NSMutableArray *_infoArr;
}
@end

@implementation JPushInfoModel

-(id)init{
    self = [super init];
    if(self){
        _infoArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)loadJPushMessageInfoWit:(NSInteger)messageID{
    [self setStatus:E_ModelDataStatus_Loading];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userObj.user, @"phone", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)messageID], @"msg_id", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_JPushMessageInfo httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
//        __block JPushInfoModel *blockSelf = self;
        if(retData.code != 0){
            [self setStatus:E_ModelDataStatus_LoadFailed];
            if(_delegate && [_delegate respondsToSelector:@selector(loadJPushMessageFailed:)]){
                [_delegate loadJPushMessageFailed:retData.errorDesc];
            }
        }else{
            [self setStatus:E_ModelDataStatus_LoadSucceed];
            if(_delegate && [_delegate respondsToSelector:@selector(loadJPushMessageSucceed)]){
                [_delegate loadJPushMessageSucceed];
            }
        }
    }];
}

@end
