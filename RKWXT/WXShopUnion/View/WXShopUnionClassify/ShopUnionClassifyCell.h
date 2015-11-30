//
//  ShopUnionClassifyCell.h
//  RKWXT
//
//  Created by SHB on 15/11/26.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol ShopUnionClassifyCellDelegate;
@interface ShopUnionClassifyCell : WXUITableViewCell
@property (nonatomic,assign)id<ShopUnionClassifyCellDelegate>delegate;

@end

@protocol ShopUnionClassifyCellDelegate <NSObject>
- (void)clickClassifyBtnAtIndex:(NSInteger)index;

@end