//
//  MyClientPersonModel.m
//  RKWXT
//
//  Created by SHB on 15/9/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "MyClientPersonModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "MyClientEntity.h"

@interface MyClientPersonModel(){
    NSMutableArray *_clientList;
}
@end

@implementation MyClientPersonModel
@synthesize clientList = _clientList;

-(id)init{
    self = [super init];
    if(self){
        _clientList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)loadMyClientPersonList:(MyClient_Grade)client_grade{
    if(client_grade > MyClient_Grade_Invalid){
        return;
    }
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", userObj.sellerID, @"seller_user_id", [NSNumber numberWithInt:(int)kMerchantID], @"sid", [NSNumber numberWithInt:(int)client_grade], @"level", nil];
    __block MyClientPersonModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_LoadMyClientPerson httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadMyClientPersonListFailed:)]){
                [_delegate loadMyClientPersonListFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseMyClientPersonListWith:[retData.data objectForKey:@"data"]];
            if(_delegate && [_delegate respondsToSelector:@selector(loadMyClientPersonListSucceed)]){
                [_delegate loadMyClientPersonListSucceed];
            }
        }
    }];
}

-(void)parseMyClientPersonListWith:(NSArray*)arr{
    if(!arr){
        return;
    }
    [_clientList removeAllObjects];
    for(NSDictionary *dic in arr){
        MyClientEntity *entity = [MyClientEntity initMyClientPersonWithDic:dic];
        entity.userIconImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.userIconImg];
        [_clientList addObject:entity];
    }
}

@end
