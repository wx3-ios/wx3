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

@implementation BalanceModel

-(void)dealloc{
    _delegate = nil;
}

-(id)init{
    self = [super init];
    if(self){
        
    }
    return self;
}

-(void)loadUserBalance{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:0,@"shop_id", 1,@"seller_id",2,@"area_id",nil];
//    __block BalanceModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchDataFromFeedType:WXT_UrlFeed_Type_LoadBalance httpMethod:WXT_HttpMethod_Get timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData){
        if (retData.code != WXT_URLFeedData_Succeed){
            if (_delegate && [_delegate respondsToSelector:@selector(loadUserBalanceFailed)]){
                [_delegate loadUserBalanceFailed];
            }
        }else{
//            [blockSelf parseClassifyData:retData.data];
            if (_delegate && [_delegate respondsToSelector:@selector(loadUserBalanceSucceed)]){
                [_delegate loadUserBalanceSucceed];
            }
        }
    }];
}

@end
