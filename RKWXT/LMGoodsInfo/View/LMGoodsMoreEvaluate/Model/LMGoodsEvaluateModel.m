//
//  LMGoodsEvaluateModel.m
//  RKWXT
//
//  Created by SHB on 15/12/29.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMGoodsEvaluateModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "LMGoodsEvaluateEntity.h"

@interface LMGoodsEvaluateModel(){
    NSMutableArray *_evaluateArr;
}
@end

@implementation LMGoodsEvaluateModel
@synthesize evaluateArr = _evaluateArr;

-(id)init{
    self = [super init];
    if(self){
        _evaluateArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseMoreEvaluateData:(NSArray*)arr{
    if([arr count] == 0){
        return;
    }
    [_evaluateArr removeAllObjects];
    for(NSDictionary *dic in arr){
        LMGoodsEvaluateEntity *entity = [LMGoodsEvaluateEntity initLMGoodsEvaluateEntity:dic];
        entity.userHeadImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.userHeadImg];
        [_evaluateArr addObject:entity];
    }
}

-(void)loadLmGoodsMoreEvaluateDat:(NSInteger)goodsID startItem:(NSInteger)startItem length:(NSInteger)length{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userObj.wxtID, @"woxin_id", [NSNumber numberWithInteger:goodsID], @"goods_id", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:2], @"type", [NSNumber numberWithInteger:startItem], @"start_item", [NSNumber numberWithInteger:length], @"length", nil];
    __block LMGoodsEvaluateModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_Home_OrderEvaluate httpMethod:WXT_HttpMethod_Post timeoutIntervcal:10 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            if (_delegate && [_delegate respondsToSelector:@selector(loadLmGoodsMoreEvaluateDataFailed:)]){
                [_delegate loadLmGoodsMoreEvaluateDataFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseMoreEvaluateData:[retData.data objectForKey:@"data"]];
            if (_delegate && [_delegate respondsToSelector:@selector(loadLmGoodsMoreEvaluateDataSucceed)]){
                [_delegate loadLmGoodsMoreEvaluateDataSucceed];
            }
        }
    }];
}

@end
