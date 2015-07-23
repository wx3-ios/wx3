//
//  NewGoodsInfoDesCell.h
//  RKWXT
//
//  Created by SHB on 15/6/4.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol PayAttentionToGoodsDelegate;

@interface NewGoodsInfoDesCell : WXUITableViewCell
@property (nonatomic,assign) id<PayAttentionToGoodsDelegate>delegate;
@end

@protocol PayAttentionToGoodsDelegate <NSObject>
-(void)payAttentionToSomeGoods:(WXUIButton*)btn;

@end
