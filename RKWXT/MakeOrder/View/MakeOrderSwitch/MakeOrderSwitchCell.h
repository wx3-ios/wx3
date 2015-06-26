//
//  MakeOrderSwitchCell.h
//  RKWXT
//
//  Created by SHB on 15/6/25.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol MakeOrderSwitchCellDelegate;

@interface MakeOrderSwitchCell : WXUITableViewCell
@property (nonatomic,assign) id<MakeOrderSwitchCellDelegate>delegate;
@end

@protocol MakeOrderSwitchCellDelegate <NSObject>
-(void)switchValueChanged;

@end
