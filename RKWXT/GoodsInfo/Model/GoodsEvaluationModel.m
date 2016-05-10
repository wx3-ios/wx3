//
//  GoodsEvaluationModel.m
//  RKWXT
//
//  Created by app on 16/4/26.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "GoodsEvaluationModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "WXTURLFeedOBJ.h"
#import "GoodsEvaluationEntity.h"

@interface GoodsEvaluationModel ()
{
    NSMutableArray *_goAtionArr;
    NSInteger _count;
}
@end

@implementation GoodsEvaluationModel
@synthesize goAtionArr = _goAtionArr;

- (instancetype)init{
    if (self  = [super init]) {
        _goAtionArr = [NSMutableArray array];
    }
    return self;
}

/*
 接口名称：订单评价
 接口地址：https://oldyun.67call.com/wx3api/wx_order_evaluate.php
 请求方式：POST
 公共参数：
 pid:平台类型(android,ios,web),
 ver:版本号,
 ts:时间戳,
 woxin_id:我信ID,
 type : 1:添加，2:查询商品评价
 添加参数:
 order_id: 订单ID
 evaluate : 商品ID^评分^内容^^商品ID^评分^内容 demo:1000023^4^烂,很烂^^1000028^4^好,很好 (客户端需过滤评价内容里的‘^’字符)
 查询商品评价:
 goods_id : 商品ID
 start_item: 查询起始条目
 length: 查询的条目数量
 返回数据格式：json
 成功返回: error ：0  data:数据
 失败返回：error ：1  msg:错误信息
 */
- (void)lookGoodsEvaluationGoodsID:(NSInteger)goodsID start:(NSInteger)start length:(NSInteger)length{
    _count = start;
     WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pid"] = @"ios";
    dic[@"ver"] = [UtilTool currentVersion];
    dic[@"ts"] = [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    dic[@"woxin_id"] = userObj.wxtID;
    dic[@"type"] = [NSNumber numberWithInt:2];
    dic[@"goods_id"] = [NSNumber numberWithInt:(int)goodsID];
    dic[@"start_item"] = [NSNumber numberWithInteger:start];
    dic[@"length"] = [NSNumber numberWithInteger:length];
    __block GoodsEvaluationModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_NewMall_GoodsEvaluation httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            if (_delegate && [_delegate respondsToSelector:@selector(loadGoodsEvaluationFailed:)]){
                [_delegate loadGoodsEvaluationFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseGoodInfoDetail:retData.data[@"data"]];
            if (_delegate && [_delegate respondsToSelector:@selector(loadGoodsEvaluationSucceed)]){
                [_delegate loadGoodsEvaluationSucceed];
            }
        }
    }];
    
}

- (void)parseGoodInfoDetail:(NSArray*)data{
    
    if (_count == 0) {
        [_goAtionArr removeAllObjects];
    }
    
    if ([data count] <= 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(loadGoodsNoEvaluation)]) {
            [_delegate loadGoodsNoEvaluation];
        }
        return;
    }
    
    for (NSDictionary *dic in data) {
    GoodsEvaluationEntity *entity = [GoodsEvaluationEntity goodsEvaluationEntityWithDic:dic];
    [_goAtionArr addObject:entity];
        
    }
}



@end
