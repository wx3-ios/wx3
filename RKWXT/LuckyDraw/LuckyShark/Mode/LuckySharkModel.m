//
//  LuckySharkModel.m
//  RKWXT
//
//  Created by SHB on 15/8/18.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckySharkModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "LuckySharkEntity.h"

@interface LuckySharkModel(){
    NSMutableArray *_luckyGoodsArr;
}

@end

@implementation LuckySharkModel
@synthesize luckyGoodsArr = _luckyGoodsArr;

-(id)init{
    self = [super init];
    if(self){
        _luckyGoodsArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseLuckyDataWidthDic:(NSDictionary*)dic{
    if(!dic){
        return;
    }
    [_luckyGoodsArr removeAllObjects];
    LuckySharkEntity *entity = [LuckySharkEntity initWidthLuckySharkEntityWidthDic:dic];
    entity.imgUrl = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.imgUrl];
    [_luckyGoodsArr addObject:entity];
}

-(void)loadUserShark{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.sellerID, @"seller_user_id", userObj.wxtID, @"woxin_id", userObj.user, @"phone", [NSNumber numberWithInteger:kMerchantID], @"sid", nil];
    __block LuckySharkModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_LuckyShark httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(luckySharkFailed:)]){
                [_delegate luckySharkFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseLuckyDataWidthDic:[retData.data objectForKey:@"data"]];
            if(_delegate && [_delegate respondsToSelector:@selector(luckySharkSucceed)]){
                [_delegate luckySharkSucceed];
            }
        }
    }];
}

@end