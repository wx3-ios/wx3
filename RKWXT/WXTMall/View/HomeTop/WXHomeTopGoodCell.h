//
//  MerchantImageCell.h
//  Woxin2.0
//
//  Created by qq on 14-7-28.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import "WXUITableViewCell.h"

//商家图片的Cell
@protocol WXHomeTopGoodCellDelegate;
@interface WXHomeTopGoodCell : WXUITableViewCell
@property (nonatomic,assign)id<WXHomeTopGoodCellDelegate>delegate;

@end

@protocol WXHomeTopGoodCellDelegate <NSObject>
- (void)clickTopGoodAtIndex:(NSInteger)index;
@end
