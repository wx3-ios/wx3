//
//  RightVieGoodsInfoTypeCell.h
//  RKWXT
//
//  Created by SHB on 15/6/18.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"
@class GoodsInfoEntity;
#define RightVieGoodsInfoTypeCellHeight (35)

@protocol RightGoodsTypeCellDelegate;
@interface RightVieGoodsInfoTypeCell : WXUITableViewCell
@property (nonatomic,strong) GoodsInfoEntity *goodsEntity;
@property (nonatomic,assign) id<RightGoodsTypeCellDelegate>delegate;
@end

@protocol RightGoodsTypeCellDelegate <NSObject>
-(void)selectGoodsType:(id)sender;

@end
