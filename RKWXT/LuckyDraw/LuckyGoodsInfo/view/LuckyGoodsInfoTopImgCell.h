//
//  LuckyGoodsInfoTopImgCell.h
//  RKWXT
//
//  Created by SHB on 15/8/14.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol LuckyGoodsInfoTopImgCellDelegate;

@interface LuckyGoodsInfoTopImgCell : WXUITableViewCell
@property (nonatomic,assign) id<LuckyGoodsInfoTopImgCellDelegate>delegate;

- (id)initWithLuckyReuseIdentifier:(NSString *)reuseIdentifier imageArray:(NSArray*)imageArray;
- (void)load;
@end

@protocol LuckyGoodsInfoTopImgCellDelegate <NSObject>
- (void)clickTopGoodsAtIndex:(NSInteger)index;

@end
