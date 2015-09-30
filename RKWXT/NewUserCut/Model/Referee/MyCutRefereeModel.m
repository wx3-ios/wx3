//
//  MyCutRefereeModel.m
//  RKWXT
//
//  Created by SHB on 15/9/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "MyCutRefereeModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "MyRefereeEntity.h"

@interface MyCutRefereeModel(){
    NSMutableArray *_myCutInfoArr;
}
@end

@implementation MyCutRefereeModel
@synthesize myCutInfoArr = _myCutInfoArr;

-(id)init{
    self = [super init];
    if(self){
        _myCutInfoArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)loadMyCutRefereeInfo{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", userObj.sellerID, @"seller_user_id", [NSNumber numberWithInt:(int)kMerchantID], @"sid", [NSNumber numberWithInt:(int)kSubShopID], @"shop_id", nil];
    __block MyCutRefereeModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_LoadMyCutInfo httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadMyCutRefereeInfoFailed:)]){
                [_delegate loadMyCutRefereeInfoFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseMyCutInfoDataWithDic:[retData.data objectForKey:@"data"]];
            if([_delegate respondsToSelector:@selector(loadMyCutRefereeInfoSucceed)]){
                [_delegate loadMyCutRefereeInfoSucceed];
            }
        }
    }];
}

-(void)parseMyCutInfoDataWithDic:(NSDictionary*)dic{
    if(!dic){
        return;
    }
    [_myCutInfoArr removeAllObjects];
    MyRefereeEntity *entity = [MyRefereeEntity initRefereeEntityWithDic:dic];
    entity.userIconImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.userIconImg];
    [_myCutInfoArr addObject:entity];
}

@end
