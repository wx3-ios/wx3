//
//  BalanceModel.m
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "BalanceModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+NewData.h"
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
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userDefault.sellerID, @"seller_user_id", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userDefault.user, @"phone", [NSNumber numberWithInt:(int)kMerchantID], @"sid", nil];
    __block BalanceModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_Balance httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData){
        if (retData.code != 0){
            if (_delegate && [_delegate respondsToSelector:@selector(loadUserBalanceFailed:)]){
                [_delegate loadUserBalanceFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseClassifyData:[retData.data objectForKey:@"data"]];
            if (_delegate && [_delegate respondsToSelector:@selector(loadUserBalanceSucceed)]){
                [_delegate loadUserBalanceSucceed];
            }
        }
    }];
}

@end
