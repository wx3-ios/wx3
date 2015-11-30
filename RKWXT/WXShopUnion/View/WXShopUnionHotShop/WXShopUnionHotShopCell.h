//
//  WXShopUnionHotShopCell.h
//  RKWXT
//
//  Created by SHB on 15/11/27.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXMiltiViewCell.h"

@protocol WXShopUnionHotShopCellDelegate;
@interface WXShopUnionHotShopCell : WXMiltiViewCell
@property (nonatomic,assign) id<WXShopUnionHotShopCellDelegate>delegate;
@end

@protocol WXShopUnionHotShopCellDelegate <NSObject>
-(void)shopUnionHotShopCellBtnClicked:(id)sender;

@end
