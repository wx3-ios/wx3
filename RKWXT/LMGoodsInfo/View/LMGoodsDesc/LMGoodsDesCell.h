//
//  LMGoodsDesCell.h
//  RKWXT
//
//  Created by SHB on 15/12/11.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define LMGoodsDesCellHeight (73)

@protocol LMGoodsDesCellDelegate;
@interface LMGoodsDesCell : WXUITableViewCell
@property (nonatomic,assign) id<LMGoodsDesCellDelegate>delegate;
@property (nonatomic,assign) BOOL userCut;

@end

@protocol LMGoodsDesCellDelegate <NSObject>
-(void)lmGoodsInfoDesCutBtnClicked;
-(void)lmGoodsInfoDesCarriageBtnClicked;

@end
