//
//  LMEvaluteGoodsCell.h
//  RKWXT
//
//  Created by SHB on 15/12/15.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define LMEvaluteGoodsCellHeight (83)

@protocol LMEvaluteGoodsCellDelegate;

@interface LMEvaluteGoodsCell : WXUITableViewCell
@property (nonatomic,strong) WXUITextView *textField;
@property (nonatomic,assign) id<LMEvaluteGoodsCellDelegate>delegate;
@end

@protocol LMEvaluteGoodsCellDelegate <NSObject>
-(void)userEvaluteTextFieldChanged:(LMEvaluteGoodsCell*)cell goodsID:(NSInteger)goods_id;

@end
