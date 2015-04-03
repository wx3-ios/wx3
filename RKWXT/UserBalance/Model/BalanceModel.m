//
//  BalanceModel.m
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "BalanceModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+Data.h"
#import "BalanceEntity.h"

@interface BalanceModel(){
    NSMutableArray *_dataList;
}
@end

@implementation BalanceModel
@synthesize dataList = _dataList;

-(id)init{
    if(self = [super init]){
        _dataList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseClassifyData:(NSDictionary*)dic{
    if(!dic){
        return;
    }
    [_dataList removeAllObjects];
    BalanceEntity *entity = [BalanceEntity initUserBalanceWithDic:dic];
    [_dataList addObject:entity];
}

-(void)loadUserBalance{
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"get_balance", @"cmd", userDefault.wxtID, @"user_id", [NSNumber numberWithInt:(int)kMerchantID], @"agent_id", userDefault.token, @"token", nil];
    __block BalanceModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchDataFromFeedType:WXT_UrlFeed_Type_LoadBalance httpMethod:WXT_HttpMethod_Get timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData){
        NSDictionary *dic = retData.data;
        NSInteger secceed = [[dic objectForKey:@"success"] integerValue];
        if (secceed != 1){
            if (_delegate && [_delegate respondsToSelector:@selector(loadUserBalanceFailed:)]){
                [_delegate loadUserBalanceFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseClassifyData:retData.data];
            if (_delegate && [_delegate respondsToSelector:@selector(loadUserBalanceSucceed)]){
                [_delegate loadUserBalanceSucceed];
            }
        }
    }];
}

@end
