//
//  WXUITextFieldCell.h
//  CallTesting
//
//  Created by le ting on 5/13/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#define kTextFieldGap (10.0)

#import "WXUITableViewCell.h"

@protocol WXUITextFieldCellDelegate;
@interface WXUITextFieldCell : WXUITableViewCell
//默认为100
@property (nonatomic,assign)CGFloat textLabelWidth;
@property (nonatomic,readonly)WXUITextField *textField;
@property (nonatomic,strong) NSString *alertText;
@property (nonatomic,assign)id<WXUITextFieldCellDelegate>delegate;
@end

@protocol WXUITextFieldCellDelegate <NSObject>
@optional
- (void)textFiledValueDidChanged:(WXUITextFieldCell*)cell;

@end
