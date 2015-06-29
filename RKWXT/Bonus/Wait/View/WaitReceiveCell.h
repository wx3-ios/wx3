//
//  WaitReceiveCell.h
//  RKWXT
//
//  Created by SHB on 15/6/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol ReceiveBonusDelegate;
@interface WaitReceiveCell : WXUITableViewCell
@property (nonatomic,assign) id<ReceiveBonusDelegate>delegate;
@end

@protocol ReceiveBonusDelegate <NSObject>
-(void)receiveBonus:(id)sender;

@end
