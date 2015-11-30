//
//  HomeLimitBuyCell.h
//  RKWXT
//
//  Created by SHB on 15/11/27.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXMiltiViewCell.h"

@protocol HomeLimitBuyCellDelegate;
@interface HomeLimitBuyCell : WXMiltiViewCell
@property (nonatomic,assign)id<HomeLimitBuyCellDelegate>delegate;
@end

@protocol HomeLimitBuyCellDelegate <NSObject>
-(void)HomeLimitBuyCellBtnClicked:(id)entity;

@end
