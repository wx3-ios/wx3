//
//  WaitSendConsultCell.h
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTUITableViewCell.h"

#define WaitSendConsultCellHeight (56)

@protocol WaitSendOrderDelegate;

@interface WaitSendConsultCell : WXTUITableViewCell
@property (nonatomic,assign) id<WaitSendOrderDelegate>delegate;
@end

@protocol WaitSendOrderDelegate <NSObject>
-(void)userClickHurryBtn:(id)sender;
-(void)userClickRefundBtn:(id)sender;

@end
