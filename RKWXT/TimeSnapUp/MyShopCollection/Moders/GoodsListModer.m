//
//  GoodsListModer.m
//  RKWXT
//
//  Created by app on 15/11/26.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "GoodsListModer.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "GoodsListInfo.h"
#import "MerchantID.h"
#import "TimeShopData.h"


@implementation GoodsListModer


- (NSMutableArray*)goodsID{
    if (!_goodsID) {
        _goodsID = [NSMutableArray array];
    }
    return _goodsID;
}

- (void)analyticalDictionary:(NSDictionary*)data{
    NSMutableArray *array = data[@"data"];

    for (NSDictionary *dict in array) {
        
        MerchantID *chant = [[MerchantID alloc]initWithDict:dict];
        [self.goodsID addObject:chant];
        
    }
    
    
}



- (void)requestNotWork:(NSInteger)type{
    WXTUserOBJ *userobj = [WXTUserOBJ sharedUserOBJ];
    NSDate *localDate = [NSDate date]; //获取当前时间
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localDate timeIntervalSince1970]];  //转化为UNIX时间戳
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"pid"] = @"ios";
    dict[@"ver"] =  [UtilTool currentVersion];
    dict[@"ts"] = timeSp;
    dict[@"type"] = [NSNumber numberWithInt:type];
    dict[@"seller_user_id"] = userobj.sellerID;
    
    __block GoodsListModer *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_PayAttention httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dict completion:^(URLFeedData *retData) {
        
        if (retData.code != 0) {
            
            if (_delegate && [_delegate respondsToSelector:@selector(requestNotWorkFailure:)]) {
                [_delegate requestNotWorkFailure:retData.errorDesc];
            }
            
        }else{
            [blockSelf  analyticalDictionary:retData.data];
            if (_delegate && [self.delegate respondsToSelector:@selector(requestNotWorkSuccessful:)]) {
                [_delegate requestNotWorkSuccessful:self.goodsID];
            }
            
        }
        
    }];
}
@end
