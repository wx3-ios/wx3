//
//  WXShopUnionHotShopTitleCell.h
//  RKWXT
//
//  Created by SHB on 15/11/27.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol WXShopUnionHotShopTitleCellDelegate;

@interface WXShopUnionHotShopTitleCell : WXUITableViewCell
@property (nonatomic,assign) id<WXShopUnionHotShopTitleCellDelegate>delegate;
@end

@protocol WXShopUnionHotShopTitleCellDelegate <NSObject>
-(void)shopUnionHotShopTitleClicked;

@end
