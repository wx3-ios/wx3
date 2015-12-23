//
//  LMOrderInfoContactShopCell.h
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define LMOrderInfoContactShopCellHeight (54)

@protocol LMOrderInfoContactShopCellDelegate;

@interface LMOrderInfoContactShopCell : WXUITableViewCell
@property (nonatomic,assign) id<LMOrderInfoContactShopCellDelegate>delegate;
@end

@protocol LMOrderInfoContactShopCellDelegate <NSObject>
-(void)contactSellerWith:(NSString*)phone;
-(void)userRefundBtnClicked;

@end
