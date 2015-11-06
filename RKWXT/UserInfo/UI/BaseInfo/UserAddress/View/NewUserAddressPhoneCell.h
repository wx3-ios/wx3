//
//  NewUserAddressPhoneCell.h
//  RKWXT
//
//  Created by SHB on 15/11/6.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol NewUserAddressPhoneCellDelegate;
@interface NewUserAddressPhoneCell : WXUITableViewCell
//默认为100
@property (nonatomic,assign)CGFloat textLabelWidth;
@property (nonatomic,readonly)WXUITextField *textField;
@property (nonatomic,strong) NSString *alertText;
@property (nonatomic,assign)id<NewUserAddressPhoneCellDelegate>delegate;
@end

@protocol NewUserAddressPhoneCellDelegate <NSObject>
@optional
- (void)textFiledPhoneValueDidChanged:(NSString*)text;

@end
