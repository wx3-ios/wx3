//
//  EvaluteGoodsCell.h
//  RKWXT
//
//  Created by SHB on 16/4/20.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define LMEvaluteGoodsCellHeight (83)

@protocol EvaluteGoodsCellDelegate;

@interface EvaluteGoodsCell : WXUITableViewCell
@property (nonatomic,strong) WXUITextView *textField;
@property (nonatomic,assign) id<EvaluteGoodsCellDelegate>delegate;
@end

@protocol EvaluteGoodsCellDelegate <NSObject>
-(void)userEvaluteTextFieldChanged:(EvaluteGoodsCell*)cell goodsID:(NSInteger)goods_id;

@end
