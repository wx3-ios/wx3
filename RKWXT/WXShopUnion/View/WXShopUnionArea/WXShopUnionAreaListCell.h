//
//  WXShopUnionAreaListCell.h
//  RKWXT
//
//  Created by SHB on 15/11/25.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXMiltiViewCell.h"

@protocol WXShopUnionAreaListCellDelegate;

@interface WXShopUnionAreaListCell : WXMiltiViewCell
@property (nonatomic,assign)id<WXShopUnionAreaListCellDelegate>delegate;
@end

@protocol WXShopUnionAreaListCellDelegate <NSObject>
-(void)shopUnionAreaClicked:(id)entity;

@end
