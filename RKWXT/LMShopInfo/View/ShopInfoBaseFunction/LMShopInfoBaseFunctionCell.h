//
//  LMShopInfoBaseFunctionCell.h
//  RKWXT
//
//  Created by SHB on 15/12/2.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol LMShopInfoBaseFunctionCellDelegate;

@interface LMShopInfoBaseFunctionCell : WXUITableViewCell
@property (nonatomic,assign) id<LMShopInfoBaseFunctionCellDelegate>delegate;
@end

@protocol LMShopInfoBaseFunctionCellDelegate <NSObject>
-(void)lmShopInfoBaseFunctionBtnClicked:(NSInteger)index;

@end
