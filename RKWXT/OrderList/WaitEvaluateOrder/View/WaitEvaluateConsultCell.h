//
//  WaitEvaluateConsultCell.h
//  RKWXT
//
//  Created by SHB on 16/4/20.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXTUITableViewCell.h"

#define WaitEvaluateConsultCellHeight (40)

@protocol WaitEvaluateConsultCellDelegate;

@interface WaitEvaluateConsultCell : WXTUITableViewCell
@property (nonatomic,assign) id<WaitEvaluateConsultCellDelegate>delegate;
@end

@protocol WaitEvaluateConsultCellDelegate <NSObject>
-(void)userEvaluateOrder:(id)sender;

@end
