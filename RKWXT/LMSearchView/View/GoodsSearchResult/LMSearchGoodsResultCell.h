//
//  LMSearchGoodsResultCell.h
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXMiltiViewCell.h"

#define LMSearchGoodsResultCellHeight (220)

@protocol LMSearchGoodsResultCellDelegate;

@interface LMSearchGoodsResultCell : WXMiltiViewCell
@property (nonatomic,assign) id<LMSearchGoodsResultCellDelegate>delegate;
@end

@protocol LMSearchGoodsResultCellDelegate <NSObject>
-(void)lmSearchGoodsBtnClicked:(id)sender;

@end
