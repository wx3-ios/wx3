//
//  WXUITextFieldCell.m
//  CallTesting
//
//  Created by le ting on 5/13/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXUITextFieldCell.h"

@interface WXUITextFieldCell()<UITextFieldDelegate>
{
    WXUITextField *_textField;
}
@end

@implementation WXUITextFieldCell
@synthesize textLabelWidth = _textLabelWidth;
@synthesize delegate = _delegate;

- (void)dealloc{
    RELEASE_SAFELY(_textField);
    _delegate = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        _textField = [[WXUITextField alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
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

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    CGSize size = frame.size;
    CGFloat textLabelWidth = self.textLabelWidth;
    CGRect textFieldRect = CGRectMake(textLabelWidth, 0, size.width-textLabelWidth - kTextFieldGap, size.height);
    [_textField setFrame:textFieldRect];
}

- (void)textValueDidChanged:(id)sender{
    if(_delegate && [_delegate respondsToSelector:@selector(textFiledValueDidChanged:)]){
        [_delegate textFiledValueDidChanged:self];
    }
}

-(void)textFieldDone:(id)sender{
    [sender resignFirstResponder];
}

@end
