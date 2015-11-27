//
//  WXShopUnionActivityCell.h
//  RKWXT
//
//  Created by SHB on 15/11/27.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol WXShopUnionActivityCell;

@interface WXShopUnionActivityCell : WXUITableViewCell
@property (nonatomic,assign) id<WXShopUnionActivityCell>delegate;
@end

@protocol WXShopUnionActivityCell <NSObject>
-(void)wxShopUnionActivityCellClicked;

@end
