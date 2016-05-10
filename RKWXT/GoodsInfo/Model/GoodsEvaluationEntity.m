//
//  GoodsEvaluationEntity.m
//  RKWXT
//
//  Created by app on 16/4/26.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "GoodsEvaluationEntity.h"

@implementation GoodsEvaluationEntity
+ (instancetype)goodsEvaluationEntityWithDic:(NSDictionary*)dic{
    GoodsEvaluationEntity *entity = [[GoodsEvaluationEntity alloc]init];
    entity.userName = dic[@"nickname"];
    entity.evalTime = dic[@"add_time"];
    entity.enalContent = dic[@"content"];
    entity.userPhone = dic[@"phone"];
    NSString *icon = dic[@"pic"];
    entity.userIcon = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,icon];
    entity.count = [dic[@"score"] integerValue];
    return entity;
}
@end
