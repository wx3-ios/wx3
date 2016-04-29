//
//  GoodsEvaluationModel.h
//  RKWXT
//
//  Created by app on 16/4/26.
//  Copyright (c) 2016年 roderick. All rights reserved.
//



#import <Foundation/Foundation.h>
@protocol GoodsEvaluationModelDelegate;
@interface GoodsEvaluationModel : NSObject
@property (nonatomic,weak)id <GoodsEvaluationModelDelegate> delegate;
@property (nonatomic,strong)NSArray *goAtionArr;
- (void)lookGoodsEvaluationGoodsID:(NSInteger)goodsID start:(NSInteger)start length:(NSInteger)length;
@end

@protocol GoodsEvaluationModelDelegate <NSObject>
- (void)loadGoodsEvaluationSucceed;
- (void)loadGoodsEvaluationFailed:(NSString*)errorMsg;
- (void)loadGoodsNoEvaluation;
@end