//
//  MakeOrderUserMsgTextFieldCell.m
//  RKWXT
//
//  Created by SHB on 15/6/25.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "MakeOrderUserMsgTextFieldCell.h"
#import "MakeOrderDef.h"

@interface MakeOrderUserMsgTextFieldCell(){
}
@end

@implementation MakeOrderUserMsgTextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat xOffset = 12;
        CGFloat textHeight = 30;
        _textField = [[UITextField alloc] init];
        _textField.frame = CGRectMake(xOffset, (Order_Section_Height_UserMesg-textHeight)/2, IPHONE_SCREEN_WIDTH-2*xOffset, textHeight);
        [_textField setTextAlignment:NSTextAlignmentLeft];
        [_textField setReturnKeyType:UIReturnKeyDone];
        [_textField setPlaceholder:@"请输入备注信息"];
        [_textField setTextColor:WXColorWithInteger(0x646464)];
        [_textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_textField addTarget:self action:@selector(textfieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [_textField addTarget:self action:@selector(textFiledValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:_textField];
    }
    return self;
}

-(void)textfieldDone:(id)sender{
    [sender resignFirstResponder];
}

-(void)textFiledValueDidChanged:(id)sender{
    if(_delegate && [_delegate respondsToSelector:@selector(userMessageTextFieldChanged:)]){
        [_delegate userMessageTextFieldChanged:self];
    }
}

@end
