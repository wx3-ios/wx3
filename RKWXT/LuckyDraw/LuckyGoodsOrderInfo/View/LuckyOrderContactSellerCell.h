//
//  LuckyOrderContactSellerCell.h
//  RKWXT
//
//  Created by SHB on 15/8/17.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define LuckyOrderContactSellerCellHeight (50)

@protocol LuckyOrderContactSellerCellDelegate;

@interface LuckyOrderContactSellerCell : WXUITableViewCell
@property (nonatomic,assign) id<LuckyOrderContactSellerCellDelegate>delegate;

@end

@protocol LuckyOrderContactSellerCellDelegate <NSObject>
-(void)luckyOrderLeftBtnClicked;
-(void)luckyOrderRightBtnClicked;

@end
