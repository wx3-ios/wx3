//
//  RightGoodsSelNumCell.h
//  RKWXT
//
//  Created by SHB on 15/6/18.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define RightGoodsSelNumCellHeight (44)

@protocol RightGoodsSelNumCellDelegate;
@interface RightGoodsSelNumCell : WXUITableViewCell
@property (nonatomic,assign) id<RightGoodsSelNumCellDelegate>delegte;
@end

@protocol RightGoodsSelNumCellDelegate <NSObject>
-(void)setGoodsSelNumber:(NSInteger)number;

@end
