//
//  WaitReceiveConsultCell.h
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTUITableViewCell.h"

#define WaitReceiveConsultCellHeight (56)

@protocol ReceiveOrderDelegate;

@interface WaitReceiveConsultCell : WXTUITableViewCell
@property (nonatomic,assign) id<ReceiveOrderDelegate>delegate;
@end

@protocol ReceiveOrderDelegate <NSObject>
-(void)receiveOrderBtnClicked:(id)sender;
-(void)refundOrderBtnClicked:(id)sender;

@end
