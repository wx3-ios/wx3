//
//  LMMakeOrderUserMsgCell.h
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol LMMakeOrderUserMsgCellDelegate;

@interface LMMakeOrderUserMsgCell : WXUITableViewCell
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,assign) id<LMMakeOrderUserMsgCellDelegate>delegate;
@end

@protocol LMMakeOrderUserMsgCellDelegate <NSObject>
-(void)userMessageChanged:(LMMakeOrderUserMsgCell*)cell;

@end
