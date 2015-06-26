//
//  MakeOrderUserMsgTextFieldCell.h
//  RKWXT
//
//  Created by SHB on 15/6/25.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol MakeOrderUserMsgTextFieldCellDelegate;

@interface MakeOrderUserMsgTextFieldCell : WXUITableViewCell
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,assign) id<MakeOrderUserMsgTextFieldCellDelegate>delegate;
@end

@protocol MakeOrderUserMsgTextFieldCellDelegate <NSObject>
-(void)userMessageTextFieldChanged:(MakeOrderUserMsgTextFieldCell*)cell;

@end
