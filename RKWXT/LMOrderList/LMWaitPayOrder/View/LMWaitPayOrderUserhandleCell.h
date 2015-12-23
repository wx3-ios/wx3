//
//  LMWaitPayOrderUserhandleCell.h
//  RKWXT
//
//  Created by SHB on 15/12/15.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define LMWaitPayOrderUserhandleCellHeight (40)

@protocol LMWaitPayOrderUserhandleCellDelegate;
@interface LMWaitPayOrderUserhandleCell : WXUITableViewCell
@property (nonatomic,assign) id<LMWaitPayOrderUserhandleCellDelegate>delegate;
@end

@protocol LMWaitPayOrderUserhandleCellDelegate <NSObject>
-(void)userCancelOrder:(id)sender;
-(void)userPayOrder:(id)sender;

@end
