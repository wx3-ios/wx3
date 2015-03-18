//
//  WXUITextViewCell.m
//  CallTesting
//
//  Created by le ting on 5/16/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXUITextViewCell.h"

@interface WXUITextViewCell()<WXUITextViewDelegate>
{
    WXUITextView *_textView;
}
@end

@implementation WXUITextViewCell
@synthesize textLabelWidth = _textLabelWidth;
@synthesize textView = _textView;
@synthesize delegate = _delegate;

- (void)dealloc{
//    RELEASE_SAFELY(_textView);
//    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        _textView = [[WXUITextView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_textView setTextAlignment:NSTextAlignmentLeft];
        [_textView setWxDelegate:self];
        [_textView setFont:[UIFont systemFontOfSize:kDefaultCellTxtSize]];
        [_textView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin];
        [self.contentView addSubview:_textView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    CGSize size = frame.size;
    CGFloat textLabelWidth = self.textLabelWidth;
    CGRect textFieldRect = CGRectMake(textLabelWidth, 0, size.width-textLabelWidth - kTextViewGap, size.height);
    [_textView setFrame:textFieldRect];
}

#pragma mark UITextView
- (void)wxTextViewDidBeginEditing:(UITextView *)textView{
    
}

- (void)wxTextViewDidChange:(UITextView *)textView{
    if(_delegate && [_delegate respondsToSelector:@selector(textViewCellValueDidChanged:)]){
        [_delegate textViewCellValueDidChanged:self];
    }
}

@end
