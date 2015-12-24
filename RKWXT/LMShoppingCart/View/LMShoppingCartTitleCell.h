//
//  LMShoppingCartTitleCell.h
//  RKWXT
//
//  Created by SHB on 15/12/10.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define LMShoppingCartTitleCellHieght (44)

@protocol LMShoppingCartTitleCellBtnDelegate;
@interface LMShoppingCartTitleCell : WXUITableViewCell
@property (nonatomic,assign) id<LMShoppingCartTitleCellBtnDelegate>delegate;

@end

@protocol LMShoppingCartTitleCellBtnDelegate <NSObject>
-(void)lmShoppingCartTitleCellCircleClicked:(id)sender;
-(void)lmShoppingCartTitleCellEditClicked:(id)sender;

@end