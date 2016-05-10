//
//  GoodsEvaluationEntity.h
//  RKWXT
//
//  Created by app on 16/4/26.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsEvaluationEntity : NSObject
@property (nonatomic,copy)NSString *userName;
@property (nonatomic,copy)NSString *userPhone;
@property (nonatomic,copy)NSString *evalTime;
@property (nonatomic,copy)NSString *enalContent;
@property (nonatomic,copy)NSString *userIcon;
@property (nonatomic,assign)NSInteger count;
+ (instancetype)goodsEvaluationEntityWithDic:(NSDictionary*)dic;
@end
