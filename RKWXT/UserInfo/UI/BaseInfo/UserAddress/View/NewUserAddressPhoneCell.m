//
//  NewUserAddressPhoneCell.m
//  RKWXT
//
//  Created by SHB on 15/11/6.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "NewUserAddressPhoneCell.h"

@interface NewUserAddressPhoneCell()<UITextFieldDelegate>{
    WXUITextField *_textField;
}
@end

@implementation NewUserAddressPhoneCell
@synthesize textLabelWidth = _textLabelWidth;
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        CGFloat xOffset = 10;
        CGFloat height = 25;
        _textField = [[WXUITextField alloc] initWithFrame:CGRectMake(xOffset, (44-height)/2, IPHONE_SCREEN_WIDTH-2*xOffset, height)];
        [_textField setTextAlignment:NSTextAlignmentLeft];
        [_textField setReturnKeyType:UIReturnKeyDone];
        [_textField addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
        [_textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_textField addTarget:self action:@selector(textValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
        [_textField setFont:[UIFont systemFontOfSize:kDefaultCellTxtSize]];
        [_textField setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:_textField];
    }
    return self;
}

-(void)load{
    [_textField setPlaceholder:_alertText];
    NSString *phone = self.cellInfo;
    if(phone){
        [_textField setText:phone];
    }
}

- (void)textValueDidChanged:(id)sender{
    if(_delegate && [_delegate respondsToSelector:@selector(textFiledPhoneValueDidChanged:)]){
        [_delegate textFiledPhoneValueDidChanged:_textField.text];
    }
}

-(void)textFieldDone:(id)sender{
    [sender resignFirstResponder];
}

@end
