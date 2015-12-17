//
//  LMSellerListModel.m
//  RKWXT
//
//  Created by SHB on 15/12/17.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMSellerListModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "LMSellerListEntity.h"

@interface LMSellerListModel(){
    NSMutableArray *_sellerListArr;
}
@end

@implementation LMSellerListModel
@synthesize sellerListArr = _sellerListArr;

-(id)init{
    self = [super init];
    if(self){
        _sellerListArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseAllSellerData:(NSArray*)arr{
    if(!arr){
        return;
    }
    [_sellerListArr removeAllObjects];
    for(NSDictionary *dic in arr){
        LMSellerListEntity *entity = [LMSellerListEntity initSellerListEntityWidth:dic];
        entity.sellerImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.sellerImg];
        [_sellerListArr addObject:entity];
    }
}

-(void)loadAllSellerListData:(NSInteger)industryID{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:kMerchantID], @"sid", [NSNumber numberWithInteger:industryID], @"industry_id", [NSNumber numberWithFloat:[self userLatitude]], @"latitude", [NSNumber numberWithFloat:[self userLongitude]], @"longitude", nil];
    __block LMSellerListModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_Home_LMSellerList httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadLmSellerListDataFailed:)]){
                [_delegate loadLmSellerListDataFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseAllSellerData:[retData.data objectForKey:@"data"]];
            if(_delegate && [_delegate respondsToSelector:@selector(loadLmSellerListDataSucceed)]){
                [_delegate loadLmSellerListDataSucceed];
            }
        }
    }];
}

//用户定位纬度
-(CGFloat)userLatitude{
    WXUserOBJ *userObj = [WXUserOBJ sharedUserOBJ];
    if(userObj.userLocationLatitude > 0){
        return userObj.userLocationLatitude;
    }
    return 0.0;
}
//用户定位经度
-(CGFloat)userLongitude{
    WXUserOBJ *userObj = [WXUserOBJ sharedUserOBJ];
    if(userObj.userLocationLongitude > 0){
        return userObj.userLocationLongitude;
    }
    return 0.0;
}

@end
