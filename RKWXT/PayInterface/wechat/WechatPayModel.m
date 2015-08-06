//
//  WechatPayModel.m
//  RKWXT
//
//  Created by SHB on 15/7/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WechatPayModel.h"
#import "WechatDef.h"
#import "WechatEntity.h"
#import "WXTURLFeedOBJ+NewData.h"

@interface WechatPayModel(){
    NSMutableArray *_wechatArr;
}
@end

@implementation WechatPayModel
@synthesize wechatArr = _wechatArr;

-(id)init{
    self = [super init];
    if(self){
        _wechatArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseWechatEntityWith:(NSDictionary*)dic{
    if(!dic){
        return;
    }
    WechatEntity *entity = [WechatEntity initWechatEntityWithDic:dic];
    [_wechatArr addObject:entity];
}

-(void)wechatPayWithOrderID:(NSString*)orderID{
    if(!orderID){
        return;
    }
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.sellerID, @"seller_user_id", @"iOS", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", orderID, @"order_id", [NSNumber numberWithInt:(int)kMerchantID], @"sid", userObj.wxtID, @"woxin_id", nil];
    __block WechatPayModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_Wechat httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(wechatPayLoadFailed:)]){
                [_delegate wechatPayLoadFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseWechatEntityWith:[retData.data objectForKey:@"data"]];
            if(_delegate && [_delegate respondsToSelector:@selector(wechatPayLoadSucceed)]){
                [_delegate wechatPayLoadSucceed];
            }
        }
    }];
}

@end
