//
//  LMMakeOrderUserMsgCell.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMMakeOrderUserMsgCell.h"
#import "LMMakeOrderDef.h"

@interface LMMakeOrderUserMsgCell(){
}
@end

@implementation LMMakeOrderUserMsgCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat xOffset = 12;
        CGFloat labelWidth = 80;
        CGFloat labelHeight = 20;
        WXUILabel *nameLabel = [[WXUILabel alloc] initWithFrame:CGRectMake(xOffset, (LMMakeOrderUserMsgCellHeight-labelHeight)/2, labelWidth, labelHeight)];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setText:@"买家留言:"];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x42433e)];
        [nameLabel setFont:WXFont(15.0)];
        [self.contentView addSubview:nameLabel];
        
        xOffset += labelWidth+2;
        CGFloat textHeight = 30;
        _textField = [[UITextField alloc] init];
        _textField.frame = CGRectMake(xOffset, (LMMakeOrderUserMsgCellHeight-textHeight)/2, IPHONE_SCREEN_WIDTH-xOffset-10, textHeight);
        [_textField setTextAlignment:NSTextAlignmentLeft];
        [_textField setReturnKeyType:UIReturnKeyDone];
        [_textField setPlaceholder:@"请输入备注信息"];
        [_textField setFont:WXFont(15.0)];
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
    if(_delegate && [_delegate respondsToSelector:@selector(userMessageChanged:)]){
        [_delegate userMessageChanged:self];
    }
}

@end
