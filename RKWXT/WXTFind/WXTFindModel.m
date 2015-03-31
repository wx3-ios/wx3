//
//  WXTFindModel.m
//  RKWXT
//
//  Created by SHB on 15/3/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTFindModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+Data.h"
#import "FindEntity.h"

@interface WXTFindModel(){
    NSMutableArray *_findDataArr;
}
@end

@implementation WXTFindModel
@synthesize findDataArr = _findDataArr;

-(id)init{
    if(self = [super init]){
        _findDataArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseClassifyData:(id)data{
    if(!data){
        return;
    }
    if([data isKindOfClass:[NSDictionary class]]){
        id items = [data objectForKey:@"items"];
        if([items isKindOfClass:[NSArray class]]){
            if([items count] > 0){
                FindEntity *entity = [FindEntity initFindEntityWith:[items objectAtIndex:0]];
                [_findDataArr addObject:entity];
            }
        }
    }
}

-(void)loadFindData{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"get_discovery_item", @"cmd", userObj.wxtID, @"user_id", [NSNumber numberWithInt:ShopID], @"agent_id", userObj.token, @"token", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchDataFromFeedType:WXT_UrlFeed_Type_LoadBalance httpMethod:WXT_HttpMethod_Get timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData){
        NSDictionary *dic = retData.data;
        __block WXTFindModel *blockSelf = self;
        if ([[dic objectForKey:@"success"] integerValue] != 1){
            if (_findDelegate && [_findDelegate respondsToSelector:@selector(initFinddataFailed:)]){
                [_findDelegate initFinddataFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseClassifyData:retData.data];
            if (_findDelegate && [_findDelegate respondsToSelector:@selector(initFinddataSucceed)]){
                [_findDelegate initFinddataSucceed];
            }
        }
    }];
}

@end
