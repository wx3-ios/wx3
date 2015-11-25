//
//  NewGoodsInfoDesCell.h
//  RKWXT
//
//  Created by SHB on 15/6/4.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@class TimeShopData;
@protocol NewGoodsInfoDesCellDelegate;

@interface NewGoodsInfoDesCell : WXUITableViewCell
@property (nonatomic,assign) BOOL isLucky;
@property (nonatomic,assign) id<NewGoodsInfoDesCellDelegate>delegate;
@property (nonatomic,strong) TimeShopData *lEntity;
@property (nonatomic,assign) BOOL isAttention;
@end

@protocol NewGoodsInfoDesCellDelegate <NSObject>
-(void)goodsInfoPayAttentionBtnClicked:(id)entity;

@end
