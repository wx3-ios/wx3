//
//  LMGoodsEvaluateModel.h
//  RKWXT
//
//  Created by SHB on 15/12/29.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LMGoodsEvaluateModelDelegate;

@interface LMGoodsEvaluateModel : NSObject
@property (nonatomic,assign) id<LMGoodsEvaluateModelDelegate>delegate;
@property (nonatomic,strong) NSArray *evaluateArr;

-(void)loadLmGoodsMoreEvaluateDat:(NSInteger)goodsID startItem:(NSInteger)startItem length:(NSInteger)length;
@end

@protocol LMGoodsEvaluateModelDelegate <NSObject>
-(void)loadLmGoodsMoreEvaluateDataSucceed;
-(void)loadLmGoodsMoreEvaluateDataFailed:(NSString*)errorMsg;

@end
