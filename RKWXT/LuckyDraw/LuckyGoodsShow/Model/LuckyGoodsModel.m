//
//  LuckyGoodsModel.m
//  RKWXT
//
//  Created by SHB on 15/8/13.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckyGoodsModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "LuckyGoodsEntity.h"

@interface LuckyGoodsModel(){
    NSMutableArray *_luckyGoodsArr;
}

@end

@implementation LuckyGoodsModel
@synthesize luckyGoodsArr = _luckyGoodsArr;

-(id)init{
    self = [super init];
    if(self){
        _luckyGoodsArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseLuckyGoodsWith:(NSDictionary*)dic{
    if(!dic){
        return;
    }
    [_luckyGoodsArr removeAllObjects];
    LuckyGoodsEntity *entity = [LuckyGoodsEntity initLuckyGoodsWithDic:dic];
    [_luckyGoodsArr addObject:entity];
}

-(void)loadLuckyGoodsList{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"", @"", nil];
    __block LuckyGoodsModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_LuckyGoodsList httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadLuckyGoodsFailed:)]){
                [_delegate loadLuckyGoodsFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseLuckyGoodsWith:nil];
            if(_delegate && [_delegate respondsToSelector:@selector(loadLuckyGoodsSuceeed)]){
                [_delegate loadLuckyGoodsSuceeed];
            }
        }
    }];
}

@end
