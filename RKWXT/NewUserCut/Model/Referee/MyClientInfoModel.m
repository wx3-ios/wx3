//
//  MyClientInfoModel.m
//  RKWXT
//
//  Created by SHB on 15/9/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "MyClientInfoModel.h"
#import "WXTURLFeedOBJ+NewData.h"

@interface MyClientInfoModel(){
    NSMutableArray *_myClientInfoArr;
}
@end

@implementation MyClientInfoModel
@synthesize myClientInfoArr = _myClientInfoArr;

-(id)init{
    self = [super init];
    if(self){
        _myClientInfoArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)loadMyClientInfoWithWxID:(NSString *)wxID{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", userObj.sellerID, @"seller_user_id", [NSNumber numberWithInt:(int)kMerchantID], @"sid", wxID, @"ll_woxin_id", nil];
    __block MyClientInfoModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_LoadMyClientInfo httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadMyClientInfoFailed:)]){
                [_delegate loadMyClientInfoFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseMyCutInfoDataWithDic:[retData.data objectForKey:@"data"]];
            if([_delegate respondsToSelector:@selector(loadMyClientInfoSucceed)]){
                [_delegate loadMyClientInfoSucceed];
            }
        }
    }];
}

-(void)parseMyCutInfoDataWithDic:(NSArray*)arr{
    if(!arr){
        return;
    }
    [_myClientInfoArr removeAllObjects];
    for(NSDictionary *dic in arr){
        NSString *money = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"ivide_money"] floatValue]];
        [_myClientInfoArr addObject:money];
    }
}

@end
