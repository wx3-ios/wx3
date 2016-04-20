//
//  EvaluteUserHandleCell.h
//  RKWXT
//
//  Created by SHB on 16/4/20.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define EvaluteUserHandleCellHeight (40)

@protocol EvaluteUserHandleCellDelegate;

@interface EvaluteUserHandleCell : WXUITableViewCell
@property (nonatomic,assign) id<EvaluteUserHandleCellDelegate>delegate;
@end

@protocol EvaluteUserHandleCellDelegate <NSObject>
-(void)userEvaluateGoods:(NSInteger)score goodsID:(NSInteger)goodsID;

@end
