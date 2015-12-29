//
//  LMHomeHotGoodsCell.h
//  RKWXT
//
//  Created by SHB on 15/12/29.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXMiltiViewCell.h"

#define LMHomeHotGoodsCellHeight ()

@protocol LMHomeHotGoodsCellDelegate;
@interface LMHomeHotGoodsCell : WXMiltiViewCell
@property (nonatomic,assign) id<LMHomeHotGoodsCellDelegate>delegate;
@end

@protocol LMHomeHotGoodsCellDelegate <NSObject>
-(void)lmHomeHotShopCellBtnClicked:(id)sender;

@end
