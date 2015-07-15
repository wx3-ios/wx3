//
//  RefundStateModel.h
//  RKWXT
//
//  Created by SHB on 15/7/9.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

@protocol SearchRefundStateDelegate;

@interface RefundStateModel : T_HPSubBaseModel
@property (nonatomic,readonly) NSArray *refundStateArr;
@property (nonatomic,assign) id<SearchRefundStateDelegate>delegate;

-(void)loadRefundInfoWith:(NSInteger)orderGoodsID;
@end

@protocol SearchRefundStateDelegate <NSObject>
-(void)loadRefundStateSucceed;
-(void)loadRefundStateFailed:(NSString*)errorMsg;

@end
