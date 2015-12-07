//
//  LMShopInfoNewGoodsCell.h
//  RKWXT
//
//  Created by SHB on 15/12/3.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXMiltiViewCell.h"

@protocol LMShopInfoNewGoodsCellDelegate;
@interface LMShopInfoNewGoodsCell : WXMiltiViewCell
@property (nonatomic,assign) id<LMShopInfoNewGoodsCellDelegate>delegate;
@end

@protocol LMShopInfoNewGoodsCellDelegate <NSObject>
-(void)lmShopInfoNewGoodsBtnClicked:(id)sender;

@end
