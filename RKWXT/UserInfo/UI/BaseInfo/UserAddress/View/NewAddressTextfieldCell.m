//
//  NewAddressTextfieldCell.m
//  RKWXT
//
//  Created by SHB on 15/11/4.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "NewAddressTextfieldCell.h"

@interface NewAddressTextfieldCell()<UITextFieldDelegate>{
    WXUITextField *_textField;
}
@end

@implementation NewAddressTextfieldCell
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
    NSString *name = self.cellInfo;
    if(name){
        [_textField setText:name];
    }
}

- (void)textValueDidChanged:(id)sender{
    if(_delegate && [_delegate respondsToSelector:@selector(textFiledValueDidChanged:)]){
        [_delegate textFiledValueDidChanged:_textField.text];
    }
}

-(void)textFieldDone:(id)sender{
    [sender resignFirstResponder];
}

@end
