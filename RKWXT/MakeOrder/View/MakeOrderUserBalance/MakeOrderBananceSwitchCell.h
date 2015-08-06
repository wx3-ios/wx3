//
//  MakeOrderBananceSwitchCell.h
//  RKWXT
//
//  Created by SHB on 15/8/6.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol MakeOrderBananceSwitchCellDelegate;

@interface MakeOrderBananceSwitchCell : WXUITableViewCell
@property (nonatomic,assign) id<MakeOrderBananceSwitchCellDelegate>delegate;
@end

@protocol MakeOrderBananceSwitchCellDelegate <NSObject>
-(void)balanceSwitchValueChanged;

@end
