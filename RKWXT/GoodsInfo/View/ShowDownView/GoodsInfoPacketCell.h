//
//  GoodsInfoPacketCell.h
//  RKWXT
//
//  Created by SHB on 15/10/26.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define GoodsInfoPacketCellHeight 44.0

@protocol GoodsInfoPacketCellDelegate;

@interface GoodsInfoPacketCell : WXUITableViewCell
@property (nonatomic,assign) id<GoodsInfoPacketCellDelegate>delegate;

@end

@protocol GoodsInfoPacketCellDelegate <NSObject>
-(void)goodsInfoPacketCellBtnClicked;

@end
