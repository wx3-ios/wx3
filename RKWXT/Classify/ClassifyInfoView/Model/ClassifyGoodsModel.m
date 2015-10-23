//
//  ClassifyGoodsModel.m
//  RKWXT
//
//  Created by SHB on 15/10/23.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ClassifyGoodsModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "ClassiftGoodsEntity.h"

@interface ClassifyGoodsModel(){
    NSMutableArray *_goodsListArr;
}
@end

@implementation ClassifyGoodsModel
@synthesize goodsListArr = _goodsListArr;

-(id)init{
    self = [super init];
    if(self){
        _goodsListArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseClassifyGoodsDataWith:(NSArray*)arr{
    if(!arr){
        return;
    }
    [_goodsListArr removeAllObjects];
    for(NSDictionary *dic in arr){
        ClassiftGoodsEntity *entity = [ClassiftGoodsEntity initCLassifyGoodsListData:dic];
        entity.goodsImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.goodsImg];
        [_goodsListArr addObject:entity];
    }
}

-(void)loadClassifyGoodsListData:(NSInteger)catID{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.user, @"phone", [NSNumber numberWithInt:(int)kMerchantID], @"sid", [NSNumber numberWithInt:(int)kSubShopID], @"shop_id", [NSNumber numberWithInteger:catID], @"cat_id", nil];
    __block ClassifyGoodsModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_LoadClassifyGoodsList httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadClassifyGoodsListDataFailed:)]){
                [_delegate loadClassifyGoodsListDataFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseClassifyGoodsDataWith:[retData.data objectForKey:@"data"]];
            if(_delegate && [_delegate respondsToSelector:@selector(loadClassifyGoodsListDataSucceed)]){
                [_delegate loadClassifyGoodsListDataSucceed];
            }
        }
    }];
}

@end
